package org.indexer.domain;

import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.analysis.core.WhitespaceAnalyzer;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class QueryHandler {

    private static final Path PATH = Paths.get("target/idx0");

    private final TopDocs hits;

    public QueryHandler(String field, String terms) throws IOException, ParseException {
        try (Directory directory = FSDirectory.open(PATH)) {
            try (IndexReader reader = DirectoryReader.open(directory)) {
                IndexSearcher searcher = new IndexSearcher(reader);

                QueryParser queryParser = new QueryParser(field, new WhitespaceAnalyzer());
                Query query = queryParser.parse(terms);
                this.hits = searcher.search(query, 10);
            }
        }
    }

    public QueryHandler(int slop, String field, java.lang.String... terms) throws IOException, ParseException {
        try (Directory directory = FSDirectory.open(PATH)) {
            try (IndexReader reader = DirectoryReader.open(directory)) {
                IndexSearcher searcher = new IndexSearcher(reader);
                PhraseQuery query = new PhraseQuery(slop, field, terms);
                this.hits = searcher.search(query, 10);
            }
        }
    }

    public void printStats() throws IOException {
        try (Directory directory = FSDirectory.open(PATH)) {
            try (IndexReader reader = DirectoryReader.open(directory)) {
                IndexSearcher searcher = new IndexSearcher(reader);

                //Print the count of matching documents.
                System.out.println("Found " + hits.totalHits.toString() + " hits!");

                //Print names and scores of matching documents.
                for (ScoreDoc scoreDoc : hits.scoreDocs) {
                    Document doc = searcher.doc(scoreDoc.doc);
                    System.out.println("Name: " + doc.get("name") + " --> Score: " + scoreDoc.score);
                }
            }
        }
    }


}
