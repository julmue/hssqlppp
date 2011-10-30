src-extra/tests/Tests : src-extra/tests/Tests.o \
src-extra/tests/Database/HsSqlPpp/Tests/Tests.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/ParserTests.o \
src-extra/tests/Database/HsSqlPpp/Tests/QuasiQuoteTests.o \
src/Database/HsSqlPpp/Ast.o \
src/Database/HsSqlPpp/Parser.o \
src/Database/HsSqlPpp/Pretty.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Utils.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Expressions.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Selects.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Dml.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/CreateTable.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/MiscDdl.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/FunctionsDdl.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Plpgsql.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Misc.o \
src-extra/tests/Database/HsSqlPpp/Tests/TestUtils.o \
src/Database/HsSqlPpp/Internals/AstInternal.o \
src/Database/HsSqlPpp/Internals/TypesInternal.o \
src/Database/HsSqlPpp/Internals/TypeChecking/TypeConversion.o \
src/Database/HsSqlPpp/Internals/AnnotationInternal.o \
src/Database/HsSqlPpp/Internals/Catalog/CatalogInternal.o \
src/Database/HsSqlPpp/Utils/Utils.o \
src/Database/HsSqlPpp/Internals/TediousTypeUtils.o \
src/Database/HsSqlPpp/Parsing/ParserInternal.o \
src/Database/HsSqlPpp/Parsing/Lexer.o \
src/Database/HsSqlPpp/Parsing/ParseErrors.o \
src/Database/HsSqlPpp/Annotation.o \
src/Database/HsSqlPpp/Catalog.o \
src/Database/HsSqlPpp/Internals/Catalog/DefaultTemplate1Catalog.o \
src-extra/util/Database/HsSqlPpp/Utils/Here.o \
src/Database/HsSqlPpp/Quote.o
	$(HC) $(HC_OPTS) -o src-extra/tests/Tests src-extra/tests/Tests.o \
src-extra/tests/Database/HsSqlPpp/Tests/Tests.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/ParserTests.o \
src-extra/tests/Database/HsSqlPpp/Tests/QuasiQuoteTests.o \
src/Database/HsSqlPpp/Ast.o \
src/Database/HsSqlPpp/Parser.o \
src/Database/HsSqlPpp/Pretty.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Utils.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Expressions.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Selects.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Dml.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/CreateTable.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/MiscDdl.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/FunctionsDdl.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Plpgsql.o \
src-extra/tests/Database/HsSqlPpp/Tests/Parsing/Misc.o \
src-extra/tests/Database/HsSqlPpp/Tests/TestUtils.o \
src/Database/HsSqlPpp/Internals/AstInternal.o \
src/Database/HsSqlPpp/Internals/TypesInternal.o \
src/Database/HsSqlPpp/Internals/TypeChecking/TypeConversion.o \
src/Database/HsSqlPpp/Internals/AnnotationInternal.o \
src/Database/HsSqlPpp/Internals/Catalog/CatalogInternal.o \
src/Database/HsSqlPpp/Utils/Utils.o \
src/Database/HsSqlPpp/Internals/TediousTypeUtils.o \
src/Database/HsSqlPpp/Parsing/ParserInternal.o \
src/Database/HsSqlPpp/Parsing/Lexer.o \
src/Database/HsSqlPpp/Parsing/ParseErrors.o \
src/Database/HsSqlPpp/Annotation.o \
src/Database/HsSqlPpp/Catalog.o \
src/Database/HsSqlPpp/Internals/Catalog/DefaultTemplate1Catalog.o \
src-extra/util/Database/HsSqlPpp/Utils/Here.o \
src/Database/HsSqlPpp/Quote.o
src-extra/devel-util/MakeDefaultTemplate1Catalog : src-extra/devel-util/MakeDefaultTemplate1Catalog.o \
src-extra/util/Database/HsSqlPpp/Utils/Here.o \
src-extra/util/Database/HsSqlPpp/Utils/CatalogReader.o \
src/Database/HsSqlPpp/Internals/Catalog/CatalogInternal.o \
src-extra/util/Database/HsSqlPpp/Utils/PgUtils.o \
src/Database/HsSqlPpp/Types.o \
src/Database/HsSqlPpp/Internals/TypesInternal.o \
src/Database/HsSqlPpp/Utils/Utils.o
	$(HC) $(HC_OPTS) -o src-extra/devel-util/MakeDefaultTemplate1Catalog src-extra/devel-util/MakeDefaultTemplate1Catalog.o \
src-extra/util/Database/HsSqlPpp/Utils/Here.o \
src-extra/util/Database/HsSqlPpp/Utils/CatalogReader.o \
src/Database/HsSqlPpp/Internals/Catalog/CatalogInternal.o \
src-extra/util/Database/HsSqlPpp/Utils/PgUtils.o \
src/Database/HsSqlPpp/Types.o \
src/Database/HsSqlPpp/Internals/TypesInternal.o \
src/Database/HsSqlPpp/Utils/Utils.o