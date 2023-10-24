package org.indexer.domain;

import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class QueryHandler {

    private static final Path PATH = Paths.get("target/idx0");
    private TopDocs hits;

    public QueryHandler(String query) throws IOException, ParseException {

        // pattern "field -s slop: terms"
        Pattern fst_pattern = Pattern.compile("^(.*?)\\s-s\\s(\\d+):\\s(.*?)$");
        Matcher fst_matcher = fst_pattern.matcher(query);

        // pattern "field: query"
        Pattern snd_pattern = Pattern.compile("^(.*?):\\s(.*?)$");
        Matcher snd_matcher = snd_pattern.matcher(query);

        if (fst_matcher.matches()) {
            String field = fst_matcher.group(1);
            int slop = Integer.parseInt(fst_matcher.group(2));
            String[] terms = fst_matcher.group(3).split("\\s+");
            this.phraseQuery(slop, field, terms);
        }else if (snd_matcher.matches()) {
            String field = snd_matcher.group(1);
            String body = snd_matcher.group(2);
            this.parsedQuery(field, body);
        }else{
            throw new ParseException();
        }

    }

    private void parsedQuery(String field, String query) throws IOException, ParseException {
            try (Directory directory = FSDirectory.open(PATH)) {
                try (IndexReader reader = DirectoryReader.open(directory)) {
                    IndexSearcher searcher = new IndexSearcher(reader);
                    QueryParser queryParser = new QueryParser(field, new EnglishAnalyzer());
                    Query parsedQuery = queryParser.parse(query);
                    this.hits = searcher.search(parsedQuery, 5);
                }
            }
    }

    private void phraseQuery(int slop, String field, String[] terms) throws IOException {
        try (Directory directory = FSDirectory.open(PATH)) {
            try (IndexReader reader = DirectoryReader.open(directory)) {
                IndexSearcher searcher = new IndexSearcher(reader);
                PhraseQuery query = new PhraseQuery(slop, field, terms);
                this.hits = searcher.search(query, 5);
            }
        }
    }

    public void printStats() throws IOException {
        try (Directory directory = FSDirectory.open(PATH)) {
            try (IndexReader reader = DirectoryReader.open(directory)) {
                IndexSearcher searcher = new IndexSearcher(reader);

                //Print the count of matching documents.
                System.out.println("Found " + hits.totalHits.toString() + "!");

                //Print names and scores of matching documents.
                for (ScoreDoc scoreDoc : hits.scoreDocs) {
                    Document doc = searcher.doc(scoreDoc.doc);
                    System.out.println("Name: " + doc.get("name") + " --> Score: " + scoreDoc.score);
                }
            }
        }
    }


}
