```
pytest # Run all the valid tests 
pytest tests # run all the tests under dir 'tests'
pytest tests/basic # run all the tests under dir 'tests/basic'
pytest tests/basic/test_int.py # Run all the tests from test_init.py
pytest tests/basic/test_int.py::test_int # Run specific test
pytest tests/basic/test_class.py::TestPagingIdleActive # Run tests from specific test class 
pytest tests/basic/test_class.py::TestPagingIdleActive::test_paging_one # Run specific test 
pytest -m sanity # Run the tests marked as sanity - test_mark.py
pytest -s 
pytest -x # stop after first failure
pytest --maxfail=2 # stop after two failures
pytest -r #  Test report with detailed information 

# Debugging
pytest --pdb # invoke the Python debugger on every failure 
pytest -x --pdb # drop to PDB on first failure, then end test session
pytest --pdb --maxfail=3 # drop to PDB for first three failures
pytest --trace # invoke the Python debugger at the start of every test.
```