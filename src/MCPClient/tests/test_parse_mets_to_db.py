# -*- coding: utf8
import os
import sys

from django.test import TestCase

THIS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.abspath(os.path.join(THIS_DIR, '../lib/clientScripts')))
import parse_mets_to_db

class TestParseDublinCore(TestCase):

    def test_none_found(self):
        pass

    def test_no_sip_dc(self):
        pass

    def test_only_original(self):
        pass

    def test_get_sip_dc(self):
        pass

    def test_multipe_sip_dc(self):
        pass
