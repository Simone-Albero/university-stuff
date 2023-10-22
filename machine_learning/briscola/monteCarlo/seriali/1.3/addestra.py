from random import randint
from random import random
from time import time, sleep
import pickle
import os

def puntiCarta(carta):
    # 0=asso, 1=due, 2=tre ... 9=dieci
    # sommo +1 alla carta per semplicità
    # del calcolo dei punti
    valore = carta%10 + 1
    if valore == 1: return 11
    if valore == 3: return 10
    if valore < 8: return 0
    return valore - 6

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
    # mazzo di carte, ogni carta assume valore tra 0 a 39
    def __init__(self):
        self.carte = []
        for carta in range (0,40):
            self.carte.append(carta)

    def carteRimaste(self):
        return len(self.carte)

    def pesca(self):
        if self.carteRimaste() == 1:
            return self.carte.pop()
        n = randint(0, self.carteRimaste()-1)
        return self.carte.pop(n)

    def mischia(self):
        self.carte = []
        for carta in range (0,40):
            self.carte.append(carta)

class GiocatoreIA():
    def __init__(self, epsilon, decay):
        self.mano = []
        self.punti = 0
        self.ia = {}
        self.epsilon = epsilon
        self.decay = decay
        self.episodio = []
        self.learn = False

    def impara(self):
        self.learn = True

    def nonImparare(self):
        self.learn = False

    def reset(self):
        if self.learn:
            if self.punti>60:
                reward = 1
            elif self.punti == 60:
                reward = 0
            else:
                reward = -1
            self.assegnaReward(reward)
        self.mano = []
        self.punti = 0
        self.episodio = []

    def aggiungiInMano(self, carta):
        self.mano.append(carta)
        self.mano.sort() # ordinando le carte in mano viene
        # ridotto il numero di stati possibili (di
        # un fattore 6) in quanto smette di essere rilevante
        # l'ordine, velocizzando di fatto l'addestramento

    def aggiungiPunti(self, punti):
        self.punti += punti
    
    def statoCarta(self, carta):
        # invece di dare all'ia come informazione esattamente le
        # carte in mano, viene dato il seme delle carte e
        # dei numeri che rappresentano i punti che esse valgono
        # in modo da ridurre il numero di stati possibili
        seme = int(carta/10)
        punti = puntiCarta(carta)
        if 0<punti<10:
            punti=1
        elif punti>=10:
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
        if self.learn:
            if (random() < self.epsilon): # esploriamo mosse
                # non migliori con probabilità epsilon
                azione = randint(0,carteInMano-1)
            else:
                azione = self.azioneMigliore(stato)
            self.episodio.append((stato, azione))
        else:
            azione = self.azioneMigliore(stato) # se non stiamo
            # cercando di imparare viene semplicemente fatta la
            # mossa ritenuta migliore
        return self.mano.pop(azione)

    def assegnaReward(self, reward):
        self.episodio.reverse()
        for (stato,azione) in self.episodio:
            if self.ia.get((azione,)+stato) == None:
                self.ia[(azione,)+stato] = (reward,1)
            else:
                oldV, n = self.ia.get((azione,)+stato)
                newV = (oldV*n + reward)/(n+1)
                self.ia.update({(azione,)+stato: (newV, n+1)})
            reward *= self.decay

    def valore(self, stato, azione):
        if self.ia.get((azione,)+stato) == None:
            return 0 # valore di default
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

class GiocatoreCasuale():
    # giocatore che effettua tutte mosse a caso
    # utilizzato come benchmark delle prestazioni dell'ia
    def __init__(self):
        self.mano = []
        self.punti = 0

    def reset(self):
        self.mano = []
        self.punti = 0

    def aggiungiInMano(self, carta):
        self.mano.append(carta)
        # in questo caso non ordiniamo le carte in
        # modo da rendere le mosse più casuali possibili

    def aggiungiPunti(self, punti):
        self.punti += punti

    def tira(self, statoPartita):
        return self.mano.pop(0) # tira sempre la prima tanto
        # e' essa stessa casuale

class Environment():
    def __init__(self, epsilon, decay):
        importaDaFile = False
        path = os.getcwd()
        if os.path.exists(path+"/ia0.pk1"):
            if os.path.exists(path+"/ia1.pk1"):
                if os.path.exists(path+"/infos.pk1"):
                    importaDaFile = True
        if importaDaFile:
            self.importaDaFile(epsilon, decay)
        else:
            self.giocatore0 = GiocatoreIA(epsilon, decay)
            self.giocatore1 = GiocatoreIA(epsilon, decay)
            self.tempoTotaleAddestramento = 0
            self.totalePartiteGiocateAddestramento = 0
        self.mazzo = Mazzo()
        self.giocatoreCasuale = GiocatoreCasuale()

    def reset(self, controGiocatoreCasuale):
        if controGiocatoreCasuale:
            self.giocatore0.nonImparare()
            self.giocatore1.nonImparare()
        else:
            self.giocatore0.impara()
            self.giocatore1.impara()
        self.mazzo.mischia()
        self.giocatore0.reset()
        self.giocatore1.reset()
        self.giocatoreCasuale.reset()
        self.cartaInFondo = self.mazzo.pesca()
        self.briscoleUscite = 0
        # infos stato generico partita per l'ia
        self.briscola = int(self.cartaInFondo/10)
        self.puntiCartaInFondoAlmeno10 = (puntiCarta(self.cartaInFondo) >= 10)
        self.uscitoAlmenoUnCaricoPerOgniSeme = [False, False, False, False] # uscito almeno un carico
                                               #denara spade bastoni coppe
        self.fasciaBriscoleUscite = 0 # non diamo all'ia completa informazioni sul numero di briscole
        # uscite se ne sono uscite meno di 7 il valore di questa variabile è zero, altrimento è il
        # numero di briscole uscite. quindi possibili valori sono 0,7,8,9,10
        # questo sempre per ridurre il numero di stati e la dimensionalità del problema
        
        # scelta di chi inizia
        turnoDelGiocatore0 = randint(0,1)
        if controGiocatoreCasuale:
            if turnoDelGiocatore0 == 0:
                self.giocatoreTiraPerPrimo = self.giocatore0
                self.giocatoreTiraPerSecondo = self.giocatoreCasuale
            else:
                self.giocatoreTiraPerPrimo = self.giocatoreCasuale
                self.giocatoreTiraPerSecondo = self.giocatore0
        else:
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
        statoPartita = (puntiSecondoGiocatoreAlmeno45, self.puntiCartaInFondoAlmeno10,
                        self.briscola, self.fasciaBriscoleUscite) + tuple(self.uscitoAlmenoUnCaricoPerOgniSeme)
        cartaTirataPerPrima = self.giocatoreTiraPerPrimo.tira(statoPartita)
        # secondo tiro
        statoCartaTirataPerPrima = self.giocatore0.statoCarta(cartaTirataPerPrima)
        statoPartita = (puntiPrimoGiocatoreAlmeno45, self.puntiCartaInFondoAlmeno10,
                        self.briscola, self.fasciaBriscoleUscite) + tuple(self.uscitoAlmenoUnCaricoPerOgniSeme) + statoCartaTirataPerPrima
        cartaTirataPerSeconda = self.giocatoreTiraPerSecondo.tira(statoPartita)
        # aggiornamento stato generico
        if puntiCarta(cartaTirataPerPrima) >= 10:
            semeCarta = int(cartaTirataPerPrima/10)
            self.uscitoAlmenoUnCaricoPerOgniSeme[semeCarta] = True
        if puntiCarta(cartaTirataPerSeconda) >= 10:
            semeCarta = int(cartaTirataPerSeconda/10)
            self.uscitoAlmenoUnCaricoPerOgniSeme[semeCarta] = True
        if int(cartaTirataPerPrima/10) == self.briscola:
            self.briscoleUscite += 1
            if self.briscoleUscite >= 7:
                self.fasciaBriscoleUscite = self.briscoleUscite
        if int(cartaTirataPerSeconda/10) == self.briscola:
            self.briscoleUscite += 1
            if self.briscoleUscite >= 7:
                self.fasciaBriscoleUscite = self.briscoleUscite
        punti = puntiCarta(cartaTirataPerPrima) + puntiCarta(cartaTirataPerSeconda)
        if haPresoIlPrimo(self.briscola, cartaTirataPerPrima, cartaTirataPerSeconda):
            self.giocatoreTiraPerPrimo.aggiungiPunti(punti)
        else:
            self.giocatoreTiraPerSecondo.aggiungiPunti(punti)
            self.giocatoreTiraPerPrimo, self.giocatoreTiraPerSecondo = self.giocatoreTiraPerSecondo, self.giocatoreTiraPerPrimo

        if self.mazzo.carteRimaste() >= 1:
            self.fasePescata()

        return self.partitaFinita()

    def fasePescata(self):
        if self.mazzo.carteRimaste() > 1:
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerPrimo.aggiungiInMano(pescata)
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerSecondo.aggiungiInMano(pescata)
        else:
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerPrimo.aggiungiInMano(pescata)
            self.giocatoreTiraPerSecondo.aggiungiInMano(self.cartaInFondo)

    def partitaFinita(self):
        return (self.giocatoreTiraPerPrimo.punti>60 or
                self.giocatoreTiraPerSecondo.punti>60 or
                (self.giocatoreTiraPerPrimo.punti==60 and self.giocatoreTiraPerSecondo.punti==60))

    def addestraIA(self, numeroEpisodi):
        print("Addestramento IA con", numeroEpisodi, "episodi")
        self.simulaPartite(numeroEpisodi, controGiocatoreCasuale=False)

    def simulaPartite(self, numeroEpisodi, controGiocatoreCasuale):
        vinteDalGiocatore0 = 0
        pareggiateDalGiocatore0 = 0
        addestra = not controGiocatoreCasuale
        if addestra:
            timestampInizio = time()
        for i in range(numeroEpisodi):
            self.reset(controGiocatoreCasuale)
            finitaPartita = False
            while not finitaPartita:
                finitaPartita = self.step()
            if addestra:
                self.totalePartiteGiocateAddestramento += 1
            if self.giocatore0.punti > 60:
                vinteDalGiocatore0 += 1
            elif self.giocatore0.punti == 60:
                pareggiateDalGiocatore0 += 1
            percent = "{:.2f}".format((i*100)/numeroEpisodi)
            print(f'\r{percent}%', end = '')
        if addestra:
            tempoAddestramento = time() - timestampInizio
            self.tempoTotaleAddestramento += tempoAddestramento
        print("\rStatistiche giocatore 0")
        print(" - Percentuale vittoria:   [", 100*vinteDalGiocatore0/numeroEpisodi,"%]", sep="")
        print(" - Percentuale pareggio:   [", 100*pareggiateDalGiocatore0/numeroEpisodi, "%]", sep="")
        sconfitteDelGiocatore0 = numeroEpisodi - vinteDalGiocatore0 - pareggiateDalGiocatore0
        print(" - Percentuale sconfitta:  [", 100*sconfitteDelGiocatore0/numeroEpisodi, "%]", sep="")
        self.reset(controGiocatoreCasuale)

    def printInfosAddestramento(self):
        secondi = int(self.tempoTotaleAddestramento)
        minuti = int(secondi/60)
        secondi = secondi%60
        ore = int(minuti/60)
        minuti = minuti%60
        print("Tempo totale addestramento ia: ", ore, "h ", minuti, "m ", secondi, "s", sep="")
        totaleStatiEsplorati = len(self.giocatore0.ia)
        print("Totale stati esplorati:", totaleStatiEsplorati)
        print("Totale partite addestramento ia:", self.totalePartiteGiocateAddestramento)
        path = os.getcwd()
        if os.path.exists(path+"/ia0.pk1"):
            if os.path.exists(path+"/ia1.pk1"):
                if os.path.exists(path+"/infos.pk1"):
                    dimensioneIA0 = int((os.stat(path+"/ia0.pk1").st_size)/(1024*1024))
                    dimensioneIA1 = int((os.stat(path+"/ia1.pk1").st_size)/(1024*1024))
                    print("Dimensione ia0:", dimensioneIA0, "MB")
                    print("Dimensione ia1:", dimensioneIA1, "MB")

    def simulaControGiocatoreCasuale(self, numeroPartite=10_000):
        print("Simulazione contro giocatore che fa mosse casuali")
        self.simulaPartite(numeroPartite, controGiocatoreCasuale=True)

    def salvaIaSuFile(self):
        with open("ia0.pk1", "wb") as fp:
            pickle.dump(self.giocatore0.ia, fp)
            fp.close()
        with open("ia1.pk1", "wb") as fp:
            pickle.dump(self.giocatore1.ia, fp)
            fp.close()
        with open("infos.pk1", "wb") as fp:
            infos = {"tempoTotaleAddestramento": self.tempoTotaleAddestramento,
                     "totalePartiteGiocateAddestramento": self.totalePartiteGiocateAddestramento}
            pickle.dump(infos, fp)
            fp.close()
        print("Finito di salvare")
        dir = os.getcwd()
        dimensioneIA0 = int((os.stat(dir+"/ia0.pk1").st_size)/(1024*1024))
        dimensioneIA1 = int((os.stat(dir+"/ia1.pk1").st_size)/(1024*1024))
        print("Dimensione ia0:", dimensioneIA0, "MB")
        print("Dimensione ia1:", dimensioneIA1, "MB")

    def importaDaFile(self, epsilon, decay):
        with open('ia0.pk1', 'rb') as fp:
            ia0 = pickle.load(fp)
            fp.close()
        with open('ia1.pk1', 'rb') as fp:
            ia1 = pickle.load(fp)
            fp.close()
        with open("infos.pk1", "rb") as fp:
            infos = pickle.load(fp)
            fp.close()
        self.giocatore0 = GiocatoreIA(epsilon, decay)
        self.giocatore0.ia = ia0
        self.giocatore1 = GiocatoreIA(epsilon, decay)
        self.giocatore1.ia = ia1
        self.tempoTotaleAddestramento = infos["tempoTotaleAddestramento"]
        self.totalePartiteGiocateAddestramento = infos["totalePartiteGiocateAddestramento"]
        print("Finito di importare ia da file")

epsilon = 0.1
decay = 0.9
oreAddestramento = 2
env = Environment(epsilon, decay)
inizio = time()
while (time()-inizio) < oreAddestramento*60*60:
    for _ in range(5):
        env.addestraIA(numeroEpisodi=50_000) # dura circa una 20ina di secondi
        os.system("clear")
        env.printInfosAddestramento()
        print()
        env.simulaControGiocatoreCasuale()
        print()
        sleep(10) # pausa senno' fonde il pc
    env.salvaIaSuFile()
