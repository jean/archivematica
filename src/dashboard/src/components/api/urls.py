# This file is part of Archivematica.
#
# Copyright 2010-2013 Artefactual Systems Inc. <http://artefactual.com>
#
# Archivematica is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Archivematica is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Archivematica.  If not, see <http://www.gnu.org/licenses/>.

from django.conf.urls import patterns
from django.conf import settings

urlpatterns = patterns('components.api.views',
    (r'transfer/approve', 'approve_transfer'),
    (r'transfer/unapproved', 'unapproved_transfers'),
    (r'administration/dips/atom/levels/$', 'get_levels_of_description'),
    (r'administration/dips/atom/fetch_levels/$', 'fetch_levels_of_description_from_atom'),
    (r'filesystem/metadata/$', 'path_metadata'),
)
