default:
	jbuilder build game.exe
	rm -f game.native && ln -s _build/default/game.exe game.native
	chmod +x game.native

clean:
	rm -rf _build game.native
