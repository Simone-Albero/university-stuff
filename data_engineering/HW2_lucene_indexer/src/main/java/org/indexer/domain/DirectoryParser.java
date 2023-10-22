package org.indexer.domain;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.core.WhitespaceAnalyzer;
import org.apache.lucene.analysis.miscellaneous.PerFieldAnalyzerWrapper;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.codecs.Codec;
import org.apache.lucene.codecs.simpletext.SimpleTextCodec;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

public class DirectoryParser {

    private static final Path PATH = Paths.get("target/idx0");
    private final Analyzer analyzer;

    public DirectoryParser() {
        Map<String, Analyzer> perFieldAnalyzers = new HashMap<>();
        perFieldAnalyzers.put("name", new WhitespaceAnalyzer());
        perFieldAnalyzers.put("body", new StandardAnalyzer());

        this.analyzer = new PerFieldAnalyzerWrapper(new StandardAnalyzer(), perFieldAnalyzers);
    }

    public void parse(String path, Codec codec) throws IOException {
        try (Directory directory = FSDirectory.open(PATH)) {
            //indexing start time
            Date start = new Date();

            IndexWriterConfig config = new IndexWriterConfig(this.analyzer);
            if (codec != null) {
                config.setCodec(codec);
            }
            IndexWriter writer = new IndexWriter(directory, config);
            writer.deleteAll();

            File folder = new File(path);
            assert folder.isDirectory();

            File[] listOfFiles = folder.listFiles();
            assert listOfFiles != null;
            for (File file : listOfFiles) {
                if (file.isFile() && file.getName().endsWith(".txt")) {
                    Document doc = new Document();
                    doc.add(new TextField("name", this.fileNameParse(file), Field.Store.YES));
                    doc.add(new TextField("body", this.fileBodyParse(file), Field.Store.YES));
                    writer.addDocument(doc);
                }
            }

            writer.commit();
            writer.close();

            //indexing end time
            Date end = new Date();
            long elapsedTime = end.getTime() - start.getTime();
            System.out.println("the index creation process is done!");
            System.out.println("Time taken: " + elapsedTime + " ms.");
        }

    }

    private String fileBodyParse(File file) throws IOException{
        Scanner scanner = new Scanner(file);
        String input;
        StringBuilder stringBuilder = new StringBuilder();

        while (scanner.hasNextLine()) {
            stringBuilder.append(scanner.nextLine()).append(" ");
        }
        return stringBuilder.toString();
    }

    private String fileNameParse(File file) {
        return file.getName().substring(0, file.getName().length() -4);
    }

    public void printStats() throws IOException {
        try (Directory directory = FSDirectory.open(PATH)) {
            try (IndexReader reader = DirectoryReader.open(directory)) {
                IndexSearcher searcher = new IndexSearcher(reader);
                Collection<String> indexedFields = FieldInfos.getIndexedFields(reader);
                for (String field : indexedFields) {
                    System.out.println(searcher.collectionStatistics(field));
                }
            }
        }
    }

}
