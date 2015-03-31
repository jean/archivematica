
import datetime
from lxml import etree
import os
import sys

import archivematicaXMLNamesSpace as ns
import archivematicaCreateMETS2 as createmets2

sys.path.append('/usr/share/archivematica/dashboard')
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings.common'
from main import models


def update_header(root, now):
    """
    Update metsHdr to have LASTMODDATE.
    """
    metshdr = root.find('mets:metsHdr', namespaces=ns.NSMAP)
    metshdr.set('LASTMODDATE', now)
    return root


def update_dublincore(root, sip_uuid, now):
    """
    Add new dmdSec for updated Dublin Core info relating to entire SIP.
    """
    return root


def update_rights(root):
    """
    Add rightsMDs for updated PREMIS Rights.
    """
    return root


def add_events(root):
    """
    Add reingest events for all existing files.
    """
    return root


def add_new_files(root, now):
    """
    Add new metadata files to structMap, fileSec.  Add new amdSecs??? What events?  Parse files to add metadata to METS.
    """
    return root


def update_mets(old_mets_path, sip_uuid):
    print 'Looking for old METS at path', old_mets_path
    # Discard whitespace now so when printing later formats correctly
    parser = etree.XMLParser(remove_blank_text=True)
    root = etree.parse(old_mets_path, parser=parser)
    now = datetime.datetime.utcnow().replace(microsecond=0).isoformat('T')

    root = update_header(root, now)
    root = update_dublincore(root, sip_uuid, now)
    root = update_rights(root)
    root = add_events(root)
    root = add_new_files(root, now)
    return root

if __name__ == '__main__':
    tree = update_mets(*sys.argv[1:])
    tree.write('mets.xml', pretty_print=True)
