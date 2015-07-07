
default sigelIn = "src/test/resources/input/sigel.xml";
default dbsIn ="src/test/resources/input/dbs.csv";


sigelIn |
file-open |
decode-xml |
//(gibt es nicht als command - vgl https://github.com/culturegraph/metafacture-core/issues/235)
decode-pica-xml |
morph("src/main/resources/morph-sigel.xml") |
stream-to-triples (redirect="true") |
@x;


dbsIn |
file-open(encoding="ISO-8859-1") |
as-lines |
decode-csv(hasHeader="true") |
morph("src/main/resources/morph-dbs.xml");
stream-to-triples (redirect="true") |
@x;


@x |
wait-for-inputs("2") |
//remove entries without id
filter-triples(subjectPattern=".+") |
sort-triples(sortOrder="subject") |
collect-triples |
morph("src/main/resources/morph-enriched.xml") |
encode-json(prettyPrinting="true") |
//dafür gibt es keinen Flux command
//Konstruktor mit id-key, type, index
JsonToElasticsearchBulk("@id", "organisation", "organisations") |
write("src/test/resources/output/enriched.out.json");

