{ stdenv
, ruby_3_1
}:

stdenv.mkDerivation {
	pname = "affinibot";
	version = "TODO";

	nativeBuildInputs = [];
	buildInputs = [ ruby_3_1 ];
}
