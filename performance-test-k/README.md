This K performance testing framework can run multiple programs in multiple programming languages and collect their running time in a CSV-format file. Follow the following steps to use this framework.

# Prepare your languages and programs. 

1. Prepare the K definition `lang/lang.k` for each languages `lang`.
  * `lambdasubst` is given as an example;
  * `lang` must use `$PGM:Pgm` as the input program variable in its configuration definition;
  * Avoid complex K features;
  * Use parentheses to avoid parsing issues.
2. Prepare the test programs `prog` for language `lang` in `lang/test-programs`, for each langauge `lang`;
  * The directory must be named `test-programs`.
3. Prepare the testing profile `profile`, where each line consists of `lang prog`, where `lang` is the language and `prog` is the program. 
  * `testing-profile` is given as an example;
  * No empty lines.

# Run performance tests.

Run `./run-tests-k.sh test-profile`. You may replace `test-profile` with other testing profiles.
  * Default timeout is 60 seconds. You may change it by changing `TIMEOUT` in `run-tests-k.sh`, line 3. 
  * Comment out `remove_kompiled_definitions $1` in `run-tests-k.sh`, line 58, to avoid re-kompiling the definitions.  

The testing results will be output to file `test-profile-result` in CSV format. Each line consists of a test program, real/user/sys times in seconds. 

