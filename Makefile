MODULES = aggs_for_vecs
EXTENSION = aggs_for_vecs
EXTENSION_VERSION = 1.3.0
DATA = $(EXTENSION)--$(EXTENSION_VERSION).sql

REGRESS = setup \
					hist_2d \
					hist_md \
					pad_vec \
					vec_add \
					vec_div \
					vec_mul \
					vec_pow \
					vec_sub \
					vec_to_count \
					vec_to_max \
					vec_to_mean \
					vec_to_min \
					vec_to_sum \
					vec_to_var_samp \
					vec_trim_scale \
					vec_without_outliers

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
REGRESS_OPTS = --dbname=$(EXTENSION)_regression	# This must come *after* the include since we override the build-in --dbname.

test:
	./test/setup.sh
	PATH="./test/bats:$$PATH" bats test

bench:
	./bench/setup.sh
	./bench/bench-all.sh | tee bench-results.txt

bench-results.txt: bench

bench-report.txt: bench-results.txt
	./bench/format-table.rb < bench-results.txt | tee bench-report.txt

release:
	git archive --format zip --prefix=$(EXTENSION)-$(EXTENSION_VERSION)/ --output $(EXTENSION)-$(EXTENSION_VERSION).zip master

.PHONY: test bench release

