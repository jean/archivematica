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

from django import forms
from django.conf import settings

from main import models

class RightsForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatement
        fields = ('rightsbasis',)

    def __init__(self, *args, **kwargs):
        super(RightsForm, self).__init__(*args, **kwargs)
        self.fields['rightsbasis'].empty_label=None
        self.fields['rightsbasis'].widget.attrs['title'] = "Designation of the basis for the right or permission described in the rights statement identifier."


class RightsGrantedForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementRightsGranted
        widgets = {
            'act': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The action the preservation repository is allowed to take; eg replicate, migrate, modify, use, disseminate, delete"}),
            'restriction': forms.widgets.TextInput(attrs=settings.INPUT_ATTRS),
            'startdate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The beginning date of the rights or restrictions granted"}),
            'enddate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The ending date of the rights or restrictions granted"}),
            'enddateopen': forms.widgets.CheckboxInput(attrs={'title': 'Use "OPEN" for an open ended term of restriction. Omit end date if the ending date is unknown or the permission statement applies to many objects with different end dates.'}), }

class RightsGrantedNotesForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementRightsGrantedNote
        widgets = {
            'rightsgranted': forms.widgets.TextInput(attrs=settings.TEXTAREA_ATTRS), }

class RightsCopyrightForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementCopyright
        widgets = {
            'copyrightstatus': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "A coded designation of the copyright status of the object at the time the rights statement is recorded. E.g. Copyrighted, Public Domain, Unknown"}),
            'copyrightjurisdiction': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The country whose copyright laws apply [ISO 3166]"}),
            'copyrightstatusdeterminationdate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date that the copyright status recorded in 'copyright status' was determined."}),
            'copyrightapplicablestartdate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date when the particular copyright applies or is applied to the content."}),
            'copyrightapplicableenddate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date when the particular copyright no longer applies or is applied to the content."}), }

class RightsStatementCopyrightDocumentationIdentifierForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementCopyrightDocumentationIdentifier
        widgets = {
          'copyrightdocumentationidentifiertype': forms.widgets.TextInput(attrs=settings.INPUT_ATTRS),
          'copyrightdocumentationidentifiervalue': forms.widgets.TextInput(attrs=settings.INPUT_ATTRS),
          'copyrightdocumentationidentifierrole': forms.widgets.TextInput(attrs=settings.INPUT_ATTRS), }

class RightsCopyrightNoteForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementCopyrightNote
        widgets = {
            'copyrightnote': forms.widgets.Textarea(attrs=settings.TEXTAREA_ATTRS), }

class RightsStatuteForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementStatuteInformation
        widgets = {
            'statutejurisdiction': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The country or other political body enacting the statute."}),
            'statutecitation': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "An identifying designation for the statute."}),
            'statutedeterminationdate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date that the determination was made that the statue authorized the permission(s) noted."}),
            'statuteapplicablestartdate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date when the statute begins to apply or is applied to the content."}),
            'statuteapplicableenddate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date when the statute ceasees to apply or be applied to the content."}), }

class RightsStatuteNoteForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementStatuteInformationNote
        widgets = {
            'statutenote': forms.widgets.Textarea(attrs=settings.TEXTAREA_ATTRS), }

class RightsOtherRightsForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementOtherRightsInformation
        widgets = {
            'otherrightsbasis': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The designation of the basis for the other right or permission described in the rights statement identifier."}),
            'otherrightsapplicablestartdate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date when the other right applies or is applied to the content."}),
            'otherrightsapplicableenddate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date when the other right no longer applies or is applied to the content."}), }

class RightsLicenseForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementLicense
        widgets = {
            'licenseterms': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "Text describing the license or agreement by which permission as granted."}),
            'licenseapplicablestartdate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The date at which the license first applies or is applied to the content."}),
            'licenseapplicableenddate': forms.widgets.TextInput(attrs={'class': 'span11', 'title': "The end date at which the license no longer applies or is applied to the content."}), }

class RightsLicenseNoteForm(forms.ModelForm):
    class Meta:
        model = models.RightsStatementLicenseNote
        widgets = {
            'licensenote': forms.widgets.Textarea(attrs=settings.TEXTAREA_ATTRS), }
