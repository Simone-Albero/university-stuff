package org.indexer;

import org.apache.lucene.codecs.simpletext.SimpleTextCodec;
import org.apache.lucene.queryparser.classic.ParseException;
import org.indexer.domain.DirectoryParser;
import org.indexer.domain.QueryHandler;

import java.io.IOException;

public class Application {
    public static void main(String[] args) throws IOException, ParseException {
        DirectoryParser directoryParser = new DirectoryParser();
        directoryParser.parse("../test_corpus", new SimpleTextCodec());
        directoryParser.printStats();

        // query parser
        QueryHandler queryHandler = new QueryHandler("body: educating the heart is no education at all");
        queryHandler.printStats();

        // phrase query
        queryHandler = new QueryHandler("body -s 1: educating the heart is no education at all");
        queryHandler.printStats();
    }
}
