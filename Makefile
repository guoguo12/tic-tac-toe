default:
	ocamlbuild -r -use-ocamlfind -pkg 'core' -tag thread game.native *.ml

clean:
	rm -rf *.cmi *.cmo _build
