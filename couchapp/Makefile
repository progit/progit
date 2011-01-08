# TODO: research wildcard targets
# TODO: DRY

en: figures docs 
	@for file in `ls ../en/*/*.markdown`; do \
	  filename=`basename -s .markdown $$file`; \
	  target=./_docs/$$filename; \
	  mkdir -p $$target; \
	  cp $$file $$target/body.markdown; \
	  echo $$filename > $$target/_id; \
	done;

de: figures docs
	@for file in `ls ../de/*/*.markdown`; do \
	  filename=`basename -s .markdown $$file`; \
	  target=./_docs/$$filename; \
	  mkdir -p $$target; \
	  cp $$file $$target/body.markdown; \
	  echo $$filename > $$target/_id; \
	done;

by: figures docs
	@for file in `ls ../by/*/*.markdown`; do \
	  filename=`basename -s .markdown $$file`; \
	  target=./_docs/$$filename; \
	  mkdir -p $$target; \
	  cp $$file $$target/body.markdown; \
	  echo $$filename > $$target/_id; \
	done;

# add your target language

figures:
	mkdir -p _attachments/figures/
	cp ../figures/* _attachments/figures/

docs:
	mkdir -p _docs

clean:
	git clean -fdx
