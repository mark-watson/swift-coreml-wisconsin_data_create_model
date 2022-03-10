build_model: clean
	swift build
	swift run

clean:
	rm -f Sources/wisconsin_data/wisconsin.mlmodel*
	rm -f Sources/wisconsin_data/wisconsin.swift
