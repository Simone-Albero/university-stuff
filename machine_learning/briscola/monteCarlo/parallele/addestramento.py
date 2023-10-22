from random import randint
from random import random
from multiprocessing import Pool

def puntiCarta(carta):
    # 0=asso, 1=due, 2=tre ... 9=dieci
    # sommo +1 alla carta per semplicità
    # del calcolo dei punti
    valore = carta%10 + 1
    if valore == 1: return 11
    if valore == 3: return 10
    if valore < 8: return 0
    return (valore - 6)

def haPresoIlPrimo(briscola, cartaTirataPerPrima, cartaTirataPerSeconda):
    seme0 = int(cartaTirataPerPrima/10)
    seme1 = int(cartaTirataPerSeconda/10)
    if seme0 == seme1:
        if puntiCarta(cartaTirataPerPrima) > puntiCarta(cartaTirataPerSeconda): return True
        if puntiCarta(cartaTirataPerPrima) < puntiCarta(cartaTirataPerSeconda): return False
        return cartaTirataPerPrima > cartaTirataPerSeconda
    if seme0 == briscola: return True
    if seme1 == briscola: return False
    return True

class Mazzo():
    def __init__(self):
        self.carte = []
        for carta in range(0,40):
            self.carte.append(carta)

    def pesca(self):
        if len(self.carte) == 1:
            return self.carte.pop()
        n = randint(0, len(self.carte)-1)
        return self.carte.pop(n)

    def mischia(self):
        self.carte = []
        for carta in range(0,40):
            self.carte.append(carta)

class GiocatoreIA():
    def __init__(self, epsilon, decay, ia):
        self.mano = []
        self.punti = 0
        self.ia = ia
        self.epsilon = epsilon
        self.decay = decay
        self.episodio = []

    def reset(self):
        self.mano = []
        self.punti = 0
        self.episodio = []

    def aggiungiInMano(self, carta):
        self.mano.append(carta)
        self.mano.sort()
        # ordinando le carte in mano in base al numero
        # viene ridotto il numero di stati possibili (di
        # un fattore 6) in quanto smette di essere rilevante
        # l'ordine, velocizzando l'addestramento

    def aggiungiPunti(self, punti):
        self.punti += punti

    def statoCarta(self, carta):
        seme = int(carta/10)
        punti = puntiCarta(carta)
        if 0<punti<10:
            punti=1
        if punti>=10:
            punti=2
        return (seme, punti)

    def statoMano(self):
        statoMano = tuple()
        for carta in self.mano:
            statoMano += self.statoCarta(carta)
        return statoMano

    def tira(self, statoPartita):
        statoMano = self.statoMano()
        stato = statoMano+statoPartita
        carteInMano = len(self.mano)
        if carteInMano == 1: # non c'è nulla da scegliere
            return self.mano.pop(0) # l'unica carta in mano
        if (random() < self.epsilon): # esploriamo mosse non
            # migliori con probabilità epsilon
            azione = randint(0,carteInMano-1)
        else:
            azione = self.azioneMigliore(stato)
        self.episodio.append((stato, azione))
        return self.mano.pop(azione)

    def assegnaReward(self, episodio, reward):
        episodio.reverse()
        for (stato,azione) in episodio:
            if self.ia.get((azione,)+stato) == None:
                self.ia[(azione,)+stato] = (reward,1)
            else:
                oldV, n = self.ia.get((azione,)+stato)
                newV = (oldV*n + reward)/(n+1)
                self.ia.update({(azione,)+stato: (newV, n+1)})
            reward *= self.decay

    def valore(self, stato, azione):
        if self.ia.get((azione,)+stato) == None:
            return 0
        (value,_) = self.ia.get((azione,)+stato)
        return value

    def azioneMigliore(self, stato):
        carteInMano = len(self.mano)
        if carteInMano == 1: # non c'è nulla da scegliere
            return 0
        valoriAzioni = []
        for i in range(carteInMano):
            valoriAzioni.append(self.valore(stato,i))
        if valoriAzioni.count(0) == carteInMano: # se sono tutti 0 i
            # valori vuol dire che probabilmente non sono stati
            # esplorati, quindi la mossa viene scelta casualmente
            return randint(0,carteInMano-1)
        massimo = max(valoriAzioni)
        return valoriAzioni.index(massimo)

class Environment():
    def __init__(self, giocatore0, giocatore1):
        self.giocatore0 = giocatore0
        self.giocatore1 = giocatore1
        self.mazzo = Mazzo()

    def reset(self):
        self.mazzo.mischia()
        self.giocatore0.reset()
        self.giocatore1.reset()
        self.cartaInFondo = self.mazzo.pesca()
        # infos stato generico partita per l'ia
        self.briscola = int(self.cartaInFondo/10)
        self.valoreCartaInFondoAlmeno10 = (puntiCarta(self.cartaInFondo)>=10)
        self.carichiUsciti = 0
        # scelto chi inizia
        turnoDelGiocatore0 = randint(0,1)
        if turnoDelGiocatore0 == 0:
            self.giocatoreTiraPerPrimo = self.giocatore0
            self.giocatoreTiraPerSecondo = self.giocatore1
        else:
            self.giocatoreTiraPerPrimo = self.giocatore1
            self.giocatoreTiraPerSecondo = self.giocatore0
        for _ in range(3):
            self.fasePescata()

    def step(self): # un turno
        # info per lo stato da dare all'ia
        puntiPrimoGiocatoreAlmeno45 = self.giocatoreTiraPerPrimo.punti > 45
        puntiSecondoGiocatoreAlmeno45 = self.giocatoreTiraPerSecondo.punti > 45
        # primo tiro
        statoPartita = (puntiPrimoGiocatoreAlmeno45, puntiSecondoGiocatoreAlmeno45,
                        self.briscola, self.valoreCartaInFondoAlmeno10,
                        self.carichiUsciti)
        cartaTirataPerPrima = self.giocatoreTiraPerPrimo.tira(statoPartita)
        # secondo tiro
        statoCartaTirataPerPrima = self.giocatoreTiraPerSecondo.statoCarta(cartaTirataPerPrima)
        statoPartita = (puntiSecondoGiocatoreAlmeno45, puntiPrimoGiocatoreAlmeno45,
                        self.briscola, self.valoreCartaInFondoAlmeno10,
                        self.carichiUsciti) + statoCartaTirataPerPrima
        cartaTirataPerSeconda = self.giocatoreTiraPerSecondo.tira(statoPartita)
        # aggiornamento stato generico
        if puntiCarta(cartaTirataPerPrima) >= 10:
            self.carichiUsciti += 1
        if puntiCarta(cartaTirataPerSeconda) >= 10:
            self.carichiUsciti += 1

        punti = puntiCarta(cartaTirataPerPrima) + puntiCarta(cartaTirataPerSeconda)
        if haPresoIlPrimo(self.briscola, cartaTirataPerPrima, cartaTirataPerSeconda):
            self.giocatoreTiraPerPrimo.aggiungiPunti(punti)
        else:
            self.giocatoreTiraPerSecondo.aggiungiPunti(punti)
            self.giocatoreTiraPerPrimo, self.giocatoreTiraPerSecondo = self.giocatoreTiraPerSecondo, self.giocatoreTiraPerPrimo

        if len(self.mazzo.carte) >= 1:
            self.fasePescata()
        return self.partitaFinita()

    def fasePescata(self):
        if len(self.mazzo.carte) > 1:
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerPrimo.aggiungiInMano(pescata)
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerSecondo.aggiungiInMano(pescata)
        else:
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerPrimo.aggiungiInMano(pescata)
            self.giocatoreTiraPerSecondo.aggiungiInMano(self.cartaInFondo)

    def partitaFinita(self):
        return (self.giocatoreTiraPerPrimo.punti+self.giocatoreTiraPerSecondo.punti) == 120
    
def simulaPartitaAddestramento(environment):
    environment.reset()
    finitaPartita = False
    while not finitaPartita:
        finitaPartita = environment.step()
    if environment.giocatore0.punti>60:
        rewardGiocatore0 = 1
        rewardGiocatore1 = -1
    elif environment.giocatore0.punti>60:
        rewardGiocatore0 = 0
        rewardGiocatore1 = 0
    else:
        rewardGiocatore0 = -1
        rewardGiocatore1 = 1
    return (environment.giocatore0.episodio, rewardGiocatore0, environment.giocatore1.episodio, rewardGiocatore1)

if __name__ == "__main__":
    epsilon = 0.1
    decay = 0.9
    cores = 4
    ia0 = dict()
    ia1 = dict()
    tempoTotaleAddestramento, totalePartiteGiocateAddestramento = 0, 0
    environments = []
    for _ in range(cores):
        giocatore0 = GiocatoreIA(epsilon, decay, ia0)
        giocatore1 = GiocatoreIA(epsilon, decay, ia1)
        environments.append(Environment(giocatore0, giocatore1))

    numeroEpisodi = 1000
    with Pool(cores) as pool:
        for _ in range(int(numeroEpisodi/cores)):
            returns = pool.map(simulaPartitaAddestramento, environments)
            for (episodio0, reward0, episodio1, reward1) in returns:
                giocatore0.assegnaReward(episodio0, reward0)
                giocatore1.assegnaReward(episodio1, reward1)

print(len(giocatore0.ia))