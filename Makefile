all: 
	./project.sh

clean:
	@rm -r html; \
	rm data/*.xml

mrproper: clean
	@rm -r bin
