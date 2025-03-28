MODULES = aggs_for_vecs
EXTENSION = aggs_for_vecs
EXTENSION_VERSION = 1.4.0
# Include $(EXTENSION)--1.2.0.sql so we can test upgrades:
DATA = $(EXTENSION)--$(EXTENSION_VERSION).sql \
			 $(EXTENSION)--1.2.0.sql \
       $(EXTENSION)--1.2.0--1.2.1.sql \
       $(EXTENSION)--1.2.1--1.3.0.sql \
       $(EXTENSION)--1.3.0--1.3.1.sql \
       $(EXTENSION)--1.3.1--1.3.2.sql \
       $(EXTENSION)--1.3.2--1.4.0.sql

REGRESS = setup \
					hist_2d \
					hist_md \
					pad_vec \
					vec_elements \
					vec_add \
					vec_coalesce \
					vec_div \
					vec_mul \
					vec_pow \
					vec_sub \
					vec_agg_stat \
					vec_to_count \
					vec_to_first \
					vec_to_last \
					vec_to_max \
					vec_to_mean \
					vec_to_min \
					vec_to_sum \
					vec_to_var_samp \
					vec_to_weighted_mean \
					vec_trim_scale \
					vec_without_outliers \
					update_extension

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
REGRESS_OPTS = --dbname=$(EXTENSION)_regression	# This must come *after* the include since we override the build-in --dbname.

test:
	echo "Run make installcheck to run tests"
	exit 1

# Build and install to all versions listed in .versions.
install-all:
	./multi.sh install

# Run make installcheck for all versions listed in .versions.
installcheck-all:
	./multi.sh installcheck

bench:
	./bench/setup.sh
	./bench/bench-all.sh | tee bench-results.txt

bench-results.txt: bench

bench-report.txt: bench-results.txt
	./bench/format-table.rb < bench-results.txt | tee bench-report.txt

release:
	git tag v$(EXTENSION_VERSION)
	git archive --format zip --prefix=$(EXTENSION)-$(EXTENSION_VERSION)/ --output $(EXTENSION)-$(EXTENSION_VERSION).zip master

.PHONY: test bench release

