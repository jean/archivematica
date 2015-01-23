#!/usr/bin/python2

import ConfigParser
import os
import shutil

clientConfigFilePath = '/etc/archivematica/MCPClient/clientConfig.conf'
config = ConfigParser.SafeConfigParser()
config.read(clientConfigFilePath)
SHARED_DIR = config.get('MCPClient', 'sharedDirectoryMounted')


def clean_directory(path):
    for f in os.listdir(path):
        shutil.rmtree(f)


def clean_all_processing_directories():
    dirs = (
        os.path.join(SHARED_DIR, "failed"),
        os.path.join(SHARED_DIR, "rejected"),
        os.path.join(SHARED_DIR, "tmp"),
        os.path.join(SHARED_DIR, "watchedDirectories", "uploadedDips")
    )
    for dir in dirs:
        clean_directory(dir)

if __name__ == '__main__':
    clean_all_processing_directories()
