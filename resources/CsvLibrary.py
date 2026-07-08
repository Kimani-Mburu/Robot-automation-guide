"""
CsvLibrary.py

What this file is for:
    A small custom Robot Framework library (just a plain Python class) that
    lets test suites read login test data directly from a CSV file, instead
    of hardcoding usernames/passwords into the .robot file.

Why this exists:
    Keeping test data in data/test_users.csv means a non-coder (or anyone
    updating test accounts) can edit the CSV without touching any Robot
    Framework syntax. This is the same pattern covered in the Robot
    Framework quick reference guide's "Reading & Writing CSV Files" section.

How Robot Framework uses this:
    Any .robot file that adds:
        Library    ../../resources/CsvLibrary.py
    can then call the keyword "Read Csv As Dicts" (Robot Framework
    auto-converts read_csv_as_dicts into that keyword name).
"""
import csv


class CsvLibrary:
    """A minimal library exposing one keyword: reading a CSV as a list of dicts."""

    def read_csv_as_dicts(self, path):
        """Reads a CSV file and returns its rows as a list of dictionaries.

        Args:
            path: Full or relative path to the CSV file.

        Returns:
            A list of dicts, one per data row, keyed by the CSV's header row.
            Example, for a CSV with header "username,password,expected_result":
                [{"username": "standard_user", "password": "secret_sauce",
                  "expected_result": "success"}, ...]
        """
        with open(path, newline='', encoding='utf-8') as f:
            return list(csv.DictReader(f))
