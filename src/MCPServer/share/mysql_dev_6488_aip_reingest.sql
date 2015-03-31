-- Issue 6488

-- Cleanup
UPDATE TasksConfigs SET description='Determine processing path for this AIP version' WHERE pk='cd53e17c-1dd1-4e78-9086-e6e013a64536';  -- fix typo
UPDATE MicroServiceChainLinks SET defaultNextChainLink=NULL WHERE pk='b3c5e343-5940-4aad-8a9f-fb0eccbfb3a3';  -- choice doesn't need defaultNextChainLink
UPDATE MicroServiceChainLinks SET defaultNextChainLink='9e3dd445-551d-42d1-89ba-fe6dff7c6ee6' WHERE pk='8de9fe10-932f-4151-88b0-b50cf271e156'; -- fail set wrong
UPDATE MicroServiceChainLinks SET defaultNextChainLink='5d6a103c-9a5d-4010-83a8-6f4c61eb1478' WHERE pk='8ba83807-2832-4e41-843c-2e55ad10ea0b'; -- fail set wrong
DELETE FROM MicroServiceChainChoice WHERE chainAvailable='e5bc60f8-4e64-4363-bf01-bef67154cfed';  -- Choice at link that wasn't a choice
DELETE FROM MicroServiceChains WHERE pk='e5bc60f8-4e64-4363-bf01-bef67154cfed';
SET @d1 = '1c7726a4-9165-4809-986a-bf4477c719ca' COLLATE utf8_unicode_ci;
SET @d2 = '26cf64e2-21b5-4935-a52b-71695870f1f2' COLLATE utf8_unicode_ci;
SET @d3 = '65916156-41a5-4ed2-9472-7dca11e6bc08' COLLATE utf8_unicode_ci;
SET @d4 = '14a0678f-9c2a-4995-a6bd-5acd141eeef1' COLLATE utf8_unicode_ci;
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d1, @d2, @d3, @d4);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2, @d3, @d4);

-- Update microserviceGroups
UPDATE MicroServiceChainLinks SET microserviceGroup='Reingest AIP' WHERE pk IN ('9520386f-bb6d-4fb9-a6b6-5845ef39375f', '77c722ea-5a8f-48c0-ae82-c66a3fa8ca77', 'c103b2fb-9a6b-4b68-8112-b70597a6cd14', '60b0e812-ebbe-487e-810f-56b1b6fdd819', '31fc3f66-34e9-478f-8d1b-c29cd0012360', 'e4e19c32-16cc-4a7f-a64d-a1f180bdb164', '83d5e887-6f7c-48b0-bd81-e3f00a9da772');
UPDATE MicroServiceChainLinks SET microserviceGroup='Process submission documentation' WHERE pk IN ('576f1f43-a130-4c15-abeb-c272ec458d33');
UPDATE MicroServiceChainLinks SET microserviceGroup='Process metadata directory' WHERE pk IN ('ee438694-815f-4b74-97e1-8e7dde2cc6d5', '75fb5d67-5efa-4232-b00b-d85236de0d3f');
UPDATE MicroServiceChainLinks SET microserviceGroup='Process manually normalized files' WHERE pk IN ('ab0d3815-a9a3-43e1-9203-23a40c00c551', '91ca6f1f-feb5-485d-99d2-25eed195e330', '10c40e41-fb10-48b5-9d01-336cd958afe8', 'e76aec15-5dfa-4b14-9405-735863e3a6fa', '9e9b522a-77ab-4c17-ab08-5a4256f49d59', 'a1b65fe3-9358-479b-93b9-68f2b5e71b2b', '78b7adff-861d-4450-b6dd-3fabe96a849e');
UPDATE MicroServiceChainLinks SET microserviceGroup='Normalize' WHERE pk IN ('db9177f5-41d2-4894-be1a-a7547ed6b63a', 'cddde867-4cf9-4248-ac31-f7052fae053f');
UPDATE MicroServiceChainLinks SET microserviceGroup='Generate AIP METS' WHERE pk IN ('ccf8ec5c-3a9a-404a-a7e7-8f567d3b36a0', '53e14112-21bb-46f0-aed3-4e8c2de6678f', '88807d68-062e-4d1a-a2d5-2d198c88d8ca');
UPDATE MicroServiceChainLinks SET microserviceGroup='Add final metadata' WHERE pk IN ('c168f1ee-5d56-4188-8521-09f0c5475133', 'f060d17f-2376-4c0b-a346-b486446e46ce', '54b73077-a062-41cc-882c-4df1eba447d9', 'eeb23509-57e2-4529-8857-9d62525db048');
UPDATE MicroServiceChainLinks SET microserviceGroup='Transcribe SIP contents' WHERE pk IN ('7079be6d-3a25-41e6-a481-cee5f352fe6e', '2900f6d8-b64c-4f2a-8f7f-bb60a57394f6', '77a7fa46-92b9-418e-aa88-fbedd4114c9f');
-- Update Watched Directory
UPDATE WatchedDirectories SET watchedDirectoryPath = '%watchDirectoryPath%system/reingestAIP/' WHERE watchedDirectoryPath='%watchDirectoryPath%system/createDIPFromAIP/';
-- Rename DIPfromAIP
UPDATE TasksConfigs SET description = 'Approve AIP reingest' WHERE pk='c450501a-251f-4de7-acde-91c47cf62e36';
UPDATE MicroServiceChains SET description='Approve AIP reingest' WHERE startingLink='77c722ea-5a8f-48c0-ae82-c66a3fa8ca77';
UPDATE MicroServiceChains SET description='AIP reingest approval chain' WHERE startingLink='9520386f-bb6d-4fb9-a6b6-5845ef39375f';
-- Move Verify Checksums to after processing metadata dir
SET @verifychecksumMSCL = '88807d68-062e-4d1a-a2d5-2d198c88d8ca' COLLATE utf8_unicode_ci;
UPDATE MicroServiceChainLinks SET microserviceGroup='Prepare AIP' WHERE pk IN (@verifychecksumMSCL, 'f1e286f9-4ec7-4e19-820c-dae7b8ea7d09');
--   Remove verify
UPDATE MicroServiceChainLinks SET defaultNextChainLink='ee438694-815f-4b74-97e1-8e7dde2cc6d5' WHERE defaultNextChainLink=@verifychecksumMSCL;
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink='ee438694-815f-4b74-97e1-8e7dde2cc6d5' WHERE nextMicroServiceChainLink=@verifychecksumMSCL;
--   New predecessor point to verify
UPDATE MicroServiceChainLinks SET defaultNextChainLink=@verifychecksumMSCL WHERE defaultNextChainLink='54b73077-a062-41cc-882c-4df1eba447d9';
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink=@verifychecksumMSCL WHERE nextMicroServiceChainLink='54b73077-a062-41cc-882c-4df1eba447d9';
--   verify point to new successor
UPDATE MicroServiceChainLinks SET defaultNextChainLink='54b73077-a062-41cc-882c-4df1eba447d9' WHERE pk=@verifychecksumMSCL;
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink='54b73077-a062-41cc-882c-4df1eba447d9' WHERE microServiceChainLink=@verifychecksumMSCL;

-- Only one exit code for determine version
DELETE FROM MicroServiceChainLinksExitCodes WHERE pk='7f2d5239-b464-4837-8e01-0fc43e31395d';
UPDATE MicroServiceChainLinksExitCodes SET exitCode=0 WHERE pk='6e06fd5e-3892-4e79-b64f-069876bd95a1';

-- Skip old file ID
SET @moveToFileIDMSCL='a2173b55-abff-4d8f-97b9-79cc2e0a64fa' COLLATE utf8_unicode_ci;
SET @moveToFileIDTC='8b846431-5da9-4743-906d-2cdc4e777f8f' COLLATE utf8_unicode_ci;
UPDATE MicroServiceChainLinks SET currentTask=@moveToFileIDTC WHERE pk=@moveToFileIDMSCL;
-- Remove old style file ID
SET @d0 = 'd05eaa5e-344b-4daa-b78b-c9f27c76499d' COLLATE utf8_unicode_ci;
SET @d1 = 'f4dea20e-f3fe-4a37-b20f-0e70a7bc960e' COLLATE utf8_unicode_ci;
SET @d2 = '5bddbb67-76b4-4bcb-9b85-a0d9337e7042' COLLATE utf8_unicode_ci;
SET @d3 = 'f3efc52e-22e1-4337-b8ed-b38dac0f9f77' COLLATE utf8_unicode_ci;
SET @d4 = 'd7681789-5f98-49bb-85d4-c01b34dac5b9' COLLATE utf8_unicode_ci;
SET @d5 = 'cf26b361-dd5f-4b62-a493-6ee02728bd5f' COLLATE utf8_unicode_ci;
SET @d6 = '01292b28-9588-4a85-953b-d92b29faf4d0' COLLATE utf8_unicode_ci;
SET @d7 = '2d751fc6-dc9d-4c52-b0d9-a4454cefb359' COLLATE utf8_unicode_ci;
SET @d8 = 'b063c4ce-ada1-4e72-a137-800f1c10905c' COLLATE utf8_unicode_ci;
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d0, @d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8);
DELETE FROM MicroServiceChainLinksExitCodes WHERE nextMicroServiceChainLink in (@d0, @d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8);
DELETE FROM MicroServiceChainChoice WHERE choiceAvailableAtLink IN (@d0, @d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8);
DELETE FROM WatchedDirectories WHERE chain IN (SELECT pk FROM MicroServiceChains WHERE startingLink IN (@d0, @d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8));
DELETE FROM MicroServiceChains WHERE startingLink IN (@d0, @d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8);
DELETE FROM MicroServiceChainLinks WHERE defaultNextChainLink in (@d0, @d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d0, @d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8);

-- Remove Set faux UUIDs
SET @del = '58fcd2fd-bcdf-4e49-ad99-7e24cc8c3ba5' COLLATE utf8_unicode_ci;
UPDATE MicroServiceChainLinks SET defaultNextChainLink='e4e19c32-16cc-4a7f-a64d-a1f180bdb164' WHERE defaultNextChainLink=@del;
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink='e4e19c32-16cc-4a7f-a64d-a1f180bdb164' WHERE nextMicroServiceChainLink=@del;
DELETE FROM StandardTasksConfigs WHERE pk IN (SELECT taskTypePKReference FROM TasksConfigs WHERE pk in (SELECT currentTask FROM MicroServiceChainLinks WHERE pk IN (@del)));
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@del);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@del);

-- Normalization chain should exclude setting returnFromManuallyNormalized and postApproveNormalization
UPDATE TasksConfigsSetUnitVariable SET microServiceChainLink='f2a6f2a5-2f92-47da-b63b-30326625f6ae' WHERE pk='d8e2c7b2-5452-4c26-b57a-04caafe9f95c';
SET @d1 = '4df4cc06-3b03-4c6f-b5c4-bec12a97dc90' COLLATE utf8_unicode_ci;
SET @d2 = '5e4f7467-8637-49b2-a584-bae83dabf762' COLLATE utf8_unicode_ci;
DELETE FROM TasksConfigsSetUnitVariable WHERE pk IN (SELECT taskTypePKReference FROM TasksConfigs WHERE pk in (SELECT currentTask FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2)));
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d1, @d2);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2);

-- No need to load post approve normalization link - Approve chains just sent returnFromManualNormalized
SET @d1 = '2307b24a-a019-4b5b-a520-a6fff270a852' COLLATE utf8_unicode_ci;
SET @d2 = 'c4e109d6-38ee-4c92-b83d-bc4d360f6f2e' COLLATE utf8_unicode_ci;
UPDATE MicroServiceChains SET startingLink='b443ba1a-a0b6-4f7c-aeb2-65bd83de5e8b' WHERE startingLink=@d1;
UPDATE MicroServiceChains SET startingLink='0b5ad647-5092-41ce-9fe5-1cc376d0bc3f' WHERE startingLink=@d2;
DELETE FROM TasksConfigsUnitVariableLinkPull WHERE pk IN (SELECT taskTypePKReference FROM TasksConfigs WHERE pk in (SELECT currentTask FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2)));
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d1, @d2);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2);

-- Remove weirdness with magic link, createDip directory, and setting resumeAfterNormalizationFileIDToolSelected
SET @setPreserveNormTC = '63866950-cb04-4fe2-9b1d-9d5f1d22fc86' COLLATE utf8_unicode_ci;
SET @setPreserveNormMSCL = 'e219ed78-2eda-4263-8c0f-0c7f6a86c33e' COLLATE utf8_unicode_ci;
SET @setPreservePKref = '1871a1a5-1937-4c4d-ab05-3b0c04a0bca1' COLLATE utf8_unicode_ci;
SET @setAllNormTC = '235c3727-b138-4e62-9265-c8f07761a5fa' COLLATE utf8_unicode_ci;
SET @setAllNormMSCL = '74665638-5d8f-43f3-b7c9-98c4c8889766' COLLATE utf8_unicode_ci;
SET @setAllNormPKref = 'f85bbe03-8aca-4211-99b7-ddb7dfb24da1' COLLATE utf8_unicode_ci;
SET @fileIDMSCL = 'a2173b55-abff-4d8f-97b9-79cc2e0a64fa' COLLATE utf8_unicode_ci;
UPDATE TasksConfigs SET taskType='6f0b612c-867f-4dfd-8e43-5b35b7f882d7' WHERE pk IN (@setPreserveNormTC, @setAllNormTC); -- setUnitVariable
UPDATE TasksConfigs SET taskTypePKReference=@setPreservePKref WHERE pk=@setPreserveNormTC;
UPDATE TasksConfigs SET taskTypePKReference=@setAllNormPKref WHERE pk=@setAllNormTC;
UPDATE MicroServiceChainLinks SET defaultNextChainLink=@fileIDMSCL WHERE defaultNextChainLink='7d43afab-4d3e-4733-a3f2-84eb772e9e57';
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink=@fileIDMSCL WHERE nextMicroServiceChainLink='7d43afab-4d3e-4733-a3f2-84eb772e9e57';
SET @d1 = '7d43afab-4d3e-4733-a3f2-84eb772e9e57' COLLATE utf8_unicode_ci;
SET @d2 = '48bfc7e1-75ed-44eb-a65c-0701c022d934' COLLATE utf8_unicode_ci;
SET @d3 = 'c73acd63-19c9-4ca8-912c-311107d0454e' COLLATE utf8_unicode_ci;
SET @d4 = 'f63970a2-dc63-4ab4-80a6-9bfd72e3cf5a' COLLATE utf8_unicode_ci;
SET @d5 = 'a58bd669-79af-4999-8654-951f638d4457' COLLATE utf8_unicode_ci;
DELETE FROM WatchedDirectories WHERE chain IN (SELECT pk FROM MicroServiceChains WHERE startingLink IN (@d1, @d2, @d3, @d4, @d5));
DELETE FROM MicroServiceChains WHERE startingLink IN (@d1, @d2, @d3, @d4, @d5);
DELETE FROM TasksConfigsAssignMagicLink WHERE execute IN (@d1, @d2, @d3, @d4, @d5);
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d1, @d2, @d3, @d4, @d5);
DELETE FROM MicroServiceChainLinks WHERE defaultNextChainLink IN (@d1, @d2, @d3, @d4, @d5);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2, @d3, @d4, @d5);

-- Remove duplicate create DIP
SET @d1 = '25b5dc50-d42d-4ee2-91fc-5dcc3eef30a7' COLLATE utf8_unicode_ci;
SET @d2 = '1c0f5926-fd76-4571-a706-aa6564555199' COLLATE utf8_unicode_ci;
SET @d3 = '82c0eca0-d9b6-4004-9d77-ded9286a9ac7' COLLATE utf8_unicode_ci;
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d1, @d2, @d3);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2, @d3);

-- Remove unnecessary watchedDir for access Normalization
SET @accessNormMSCL = 'b3c5e343-5940-4aad-8a9f-fb0eccbfb3a3' COLLATE utf8_unicode_ci;
SET @d1 = 'f2a6f2a5-2f92-47da-b63b-30326625f6ae' COLLATE utf8_unicode_ci;
DELETE FROM WatchedDirectories WHERE chain IN (SELECT pk FROM MicroServiceChains WHERE startingLink=@accessNormMSCL);
DELETE FROM MicroServiceChains WHERE startingLink=@accessNormMSCL;
UPDATE TasksConfigsSetUnitVariable SET microServiceChainLink=@accessNormMSCL WHERE microServiceChainLink=@d1;
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink=@d1;
DELETE FROM MicroServiceChainLinks WHERE pk=@d1;

-- Add processingMCP
INSERT INTO MicroServiceChainLinks(pk, microserviceGroup, defaultExitMessage, currentTask, defaultNextChainLink) VALUES ('ff516d0b-2bba-414c-88d4-f3575ebf050a', 'Reingest AIP', 'Failed', 'f89b9e0f-8789-4292-b5d0-4a330c0205e1', '7d728c39-395f-4892-8193-92f086c0546f');
INSERT INTO MicroServiceChainLinksExitCodes (pk, microServiceChainLink, exitCode, nextMicroServiceChainLink, exitMessage) VALUES ('545f54cc-475c-4980-9dff-8f7e65ebaeba', 'ff516d0b-2bba-414c-88d4-f3575ebf050a', 0, '60b0e812-ebbe-487e-810f-56b1b6fdd819', 'Completed successfully');
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink='ff516d0b-2bba-414c-88d4-f3575ebf050a' WHERE microServiceChainLink='c103b2fb-9a6b-4b68-8112-b70597a6cd14';
-- Redirect to typical normalization node
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink='5d6a103c-9a5d-4010-83a8-6f4c61eb1478' WHERE microServiceChainLink IN ('83d5e887-6f7c-48b0-bd81-e3f00a9da772', 'e4e19c32-16cc-4a7f-a64d-a1f180bdb164') AND exitCode=0;

-- Don't use weird normalization node, remove unitVars for that
SET @d1 = '29dece8e-55a4-4f2c-b4c2-365ab6376ceb' COLLATE utf8_unicode_ci;
SET @d2 = '635ba89d-0ad6-4fc9-acc3-e6069dffdcd5' COLLATE utf8_unicode_ci;
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d1, @d2);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2);

-- Move MD reminder to start of submission docs
SET @mdReminderMSCL = '54b73077-a062-41cc-882c-4df1eba447d9' COLLATE utf8_unicode_ci;
SET @afterMdReminderMSCL = '77a7fa46-92b9-418e-aa88-fbedd4114c9f' COLLATE utf8_unicode_ci;
SET @createMETSMSCL='ccf8ec5c-3a9a-404a-a7e7-8f567d3b36a0' COLLATE utf8_unicode_ci;
UPDATE MicroServiceChainLinks SET defaultNextChainLink=@createMETSMSCL WHERE defaultNextChainLink=@mdReminderMSCL;
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink=@createMETSMSCL WHERE nextMicroServiceChainLink=@mdReminderMSCL;
UPDATE MicroServiceChainLinks SET defaultNextChainLink=@mdReminderMSCL WHERE defaultNextChainLink=@afterMdReminderMSCL;
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink=@mdReminderMSCL WHERE nextMicroServiceChainLink=@afterMdReminderMSCL;
UPDATE MicroServiceChains SET startingLink=@afterMdReminderMSCL WHERE startingLink=@createMETSMSCL;

-- Set MD reminder group
UPDATE MicroServiceChainLinks SET microserviceGroup='Add final metadata' WHERE pk IN (@mdReminderMSCL, 'eeb23509-57e2-4529-8857-9d62525db048', @afterMdReminderMSCL);

-- Add jsonMetadataToCSV to during post-norm metadata processing 8c8bac29-4102-4fd2-9d0a-a3bd2e607566
SET @metadataMSCL = 'b0ffcd90-eb26-4caf-8fab-58572d205f04' COLLATE utf8_unicode_ci;
INSERT INTO TasksConfigs (pk, taskType, taskTypePKReference, description) VALUES ('38b99e0c-7066-49c4-82ed-d77bd7f019a1', '36b2e239-4a57-4aa5-8ebc-7a29139baca6', '44d3789b-10ad-4a9c-9984-c2fe503c8720', 'Process JSON metadata');
INSERT INTO MicroServiceChainLinks(pk, microserviceGroup, defaultExitMessage, currentTask, defaultNextChainLink) VALUES (@metadataMSCL, 'Process metadata directory', 'Failed', '38b99e0c-7066-49c4-82ed-d77bd7f019a1', 'e4b0c713-988a-4606-82ea-4b565936d9a7');
INSERT INTO MicroServiceChainLinksExitCodes (pk, microServiceChainLink, exitCode, nextMicroServiceChainLink, exitMessage) VALUES ('f1292ec3-4749-4e64-a924-c2089f97c583', @metadataMSCL, 0, 'e4b0c713-988a-4606-82ea-4b565936d9a7', 'Completed successfully');
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink=@metadataMSCL WHERE microServiceChainLink='ee438694-815f-4b74-97e1-8e7dde2cc6d5';
UPDATE MicroServiceChainLinks SET defaultNextChainLink=@metadataMSCL WHERE pk='ee438694-815f-4b74-97e1-8e7dde2cc6d5';
-- /ingest jsonMetadataToCSV

-- Reject SIP should be the SIP chain, not transfer
UPDATE MicroServiceChainChoice SET chainAvailable='a6ed697e-6189-4b4e-9f80-29209abc7937' WHERE choiceAvailableAtLink='9520386f-bb6d-4fb9-a6b6-5845ef39375f' AND chainAvailable='1b04ec43-055c-43b7-9543-bd03c6a778ba';

-- Add parse METS to DB MSCL
SET @repopulateSTC = '12fcbb37-499b-4e1c-8164-3beb1657b6dd' COLLATE utf8_unicode_ci;
SET @repopulateTC = '507c13db-63c9-476b-9a16-0c3a05aff1cb' COLLATE utf8_unicode_ci;
SET @repopulateMSCL = '33533fbb-1607-434f-a82b-cf938c05f60b' COLLATE utf8_unicode_ci;
INSERT INTO StandardTasksConfigs (pk, requiresOutputLock, execute, arguments) VALUES (@repopulateSTC, 0, 'parseMETStoDB_v1.0', '%SIPUUID% %taskUUID% %SIPDirectory%');
INSERT INTO TasksConfigs (pk, taskType, taskTypePKReference, description) VALUES (@repopulateTC, '36b2e239-4a57-4aa5-8ebc-7a29139baca6', @repopulateSTC, 'Populate database with reingested AIP data');
INSERT INTO MicroServiceChainLinks(pk, microserviceGroup, defaultExitMessage, currentTask, defaultNextChainLink) VALUES (@repopulateMSCL, 'Reingest AIP', 'Failed', @repopulateTC, '7d728c39-395f-4892-8193-92f086c0546f');
INSERT INTO MicroServiceChainLinksExitCodes (pk, microServiceChainLink, exitCode, nextMicroServiceChainLink, exitMessage) VALUES ('7ec3b34f-7505-4459-a139-9d7f5738984c', @repopulateMSCL, 0, 'e4e19c32-16cc-4a7f-a64d-a1f180bdb164', 'Completed successfully');
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink=@repopulateMSCL WHERE microServiceChainLink='31fc3f66-34e9-478f-8d1b-c29cd0012360';

-- Merge Approve nodes

-- Replace 'load finish with metadata processing link' (f1e2) with 'check if DIP should be created' test -d %SIPDir%DIP
DELETE FROM TasksConfigsUnitVariableLinkPull WHERE pk='49c816cd-b443-498f-9369-9274d060ddd3';
INSERT INTO StandardTasksConfigs (pk, requiresOutputLock, execute, arguments) VALUES ('49c816cd-b443-498f-9369-9274d060ddd3', 0, 'test_v0.0', '-d "%SIPDirectory%DIP"');
UPDATE TasksConfigs SET taskType='36b2e239-4a57-4aa5-8ebc-7a29139baca6', description='Check if DIP should be generated' WHERE pk='a493f430-d905-4f68-a742-f4393a43e694';
-- DIP directory found
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink='378ae4fc-7b62-40af-b448-a1ab47ac2c0c' WHERE microServiceChainLink='f1e286f9-4ec7-4e19-820c-dae7b8ea7d09' AND exitCode=0;
-- DIP directory not found
INSERT INTO MicroServiceChainLinksExitCodes (pk, microServiceChainLink, exitCode, nextMicroServiceChainLink, exitMessage) VALUES ('99f8045f-8da0-40f6-8fb3-b45bfc7f3bfb', 'f1e286f9-4ec7-4e19-820c-dae7b8ea7d09', 1, '65240550-d745-4afe-848f-2bf5910457c9', 'Completed successfully');
-- Remove duplicate Approve node
DELETE FROM MicroServiceChains WHERE pk='cc884b80-3e89-4e0c-bc65-b73019fc0089';
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink='83257841-594d-4a0e-a4a1-1e9269c30f3d' WHERE nextMicroServiceChainLink='39ac9205-cb08-47b1-8bc3-d3375e37d9eb';  -- Make everything point at same approve node
UPDATE MicroServiceChainLinks SET defaultNextChainLink='83257841-594d-4a0e-a4a1-1e9269c30f3d' WHERE defaultNextChainLink='39ac9205-cb08-47b1-8bc3-d3375e37d9eb';  -- Make everything point at same approve node
-- Make WD just approveNormalization
UPDATE StandardTasksConfigs SET arguments='"%SIPDirectory%" "%sharedPath%watchedDirectories/approveNormalization/." "%SIPUUID%" "%sharedPath%" "%SIPUUID%" "%sharedPath%"' WHERE pk='87fb2e00-03b9-4890-a4d4-0e28f27e32c2';  -- Move to approveNormalization instead of approveNormalization/preservationAndAccess
UPDATE WatchedDirectories SET watchedDirectoryPath='%watchDirectoryPath%approveNormalization/' WHERE pk='fb77de49-855d-4949-bb85-553b23cdc708';  -- Change directory to watch
UPDATE MicroServiceChains SET startingLink='0f0c1f33-29f2-49ae-b413-3e043da5df61' WHERE pk='1e0df175-d56d-450d-8bee-7df1dc7ae815';  --  Remove setting unitVar node
DELETE FROM TasksConfigsSetUnitVariable WHERE pk IN ('c26b2859-7a96-462f-880a-0cd8d1b0ac32', '771dd17a-02d1-403b-a761-c70cc9cc1d1a', '6b4600f2-6df6-42cb-b611-32938b46a9cf', '5035632e-7879-4ece-bf43-2fc253026ff5', 'fc9f30bf-7f6e-4e62-9f99-689c8dc2e4ec');  -- Delete everything that sets a now unneeded unitVar
-- Remove 'set resume after metadata'
UPDATE MicroServiceChainLinksExitCodes SET nextMicroServiceChainLink = '54b73077-a062-41cc-882c-4df1eba447d9' WHERE nextMicroServiceChainLink IN ('ab0d3815-a9a3-43e1-9203-23a40c00c551', 'c168f1ee-5d56-4188-8521-09f0c5475133', 'f060d17f-2376-4c0b-a346-b486446e46ce');
UPDATE MicroServiceChainLinks SET defaultNextChainLink = '54b73077-a062-41cc-882c-4df1eba447d9' WHERE defaultNextChainLink IN ('ab0d3815-a9a3-43e1-9203-23a40c00c551', 'c168f1ee-5d56-4188-8521-09f0c5475133', 'f060d17f-2376-4c0b-a346-b486446e46ce');
-- Delete now unneeded MSCL
SET @d1 = '39ac9205-cb08-47b1-8bc3-d3375e37d9eb' COLLATE utf8_unicode_ci;
SET @d2 = 'bf6873f4-90b8-4393-9057-7f14f4687d72' COLLATE utf8_unicode_ci;
SET @d3 = '2f83c458-244f-47e5-a302-ce463163354e' COLLATE utf8_unicode_ci;
SET @d4 = '150dcb45-46c3-4529-b35f-b0a8a5a553e9' COLLATE utf8_unicode_ci;
SET @d5 = 'b443ba1a-a0b6-4f7c-aeb2-65bd83de5e8b' COLLATE utf8_unicode_ci;
SET @d6 = '0b5ad647-5092-41ce-9fe5-1cc376d0bc3f' COLLATE utf8_unicode_ci;
SET @d7 = 'f30b23d4-c8de-453d-9b92-50b86e21d3d5' COLLATE utf8_unicode_ci;
SET @d8 = 'ab0d3815-a9a3-43e1-9203-23a40c00c551' COLLATE utf8_unicode_ci;
SET @d9 = 'c168f1ee-5d56-4188-8521-09f0c5475133' COLLATE utf8_unicode_ci;
SET @d10 = 'f060d17f-2376-4c0b-a346-b486446e46ce' COLLATE utf8_unicode_ci;
DELETE FROM MicroServiceChainChoice WHERE choiceAvailableAtLink IN (@d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8, @d9, @d10);
DELETE FROM WatchedDirectories WHERE pk='2d9e4ca0-2d20-4c65-82cb-8ca23901fd5b';
DELETE FROM MicroServiceChains WHERE pk IN ('2256d500-a26e-438d-803d-3ffe17b8caf0', 'd7cf171e-82e8-4bbb-bc33-de6b8b256202', '45811f43-40d2-4efa-9c1d-876417834b7f');
DELETE FROM MicroServiceChainLinksExitCodes WHERE microServiceChainLink IN (@d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8, @d9, @d10);
DELETE FROM MicroServiceChainLinks WHERE pk IN (@d1, @d2, @d3, @d4, @d5, @d6, @d7, @d8, @d9, @d10);

-- Update metadata
ALTER TABLE Dublincore ADD status varchar(8) DEFAULT 'ORIGINAL' COLLATE utf8_unicode_ci NOT NULL;
ALTER TABLE RightsStatement ADD status varchar(8) DEFAULT 'ORIGINAL' COLLATE utf8_unicode_ci NOT NULL;
ALTER TABLE RightsStatementCopyright
    MODIFY copyrightStatusDeterminationDate longtext NULL,
    MODIFY copyrightApplicableStartDate longtext NULL,
    MODIFY copyrightApplicableEndDate longtext NULL
    ;
ALTER TABLE RightsStatementCopyrightDocumentationIdentifier MODIFY copyrightDocumentationIdentifierRole longtext NULL;
ALTER TABLE RightsStatementLicense
    MODIFY licenseApplicableStartDate longtext NULL,
    MODIFY licenseApplicableEndDate longtext NULL
    ;
ALTER TABLE RightsStatementLicenseDocumentationIdentifier MODIFY licenseDocumentationIdentifierRole longtext NULL;
ALTER TABLE RightsStatementStatuteInformation
    MODIFY statuteInformationDeterminationDate longtext NULL,
    MODIFY statuteApplicableStartDate longtext NULL,
    MODIFY statuteApplicableEndDate longtext NULL
    ;
ALTER TABLE RightsStatementStatuteDocumentationIdentifier MODIFY statuteDocumentationIdentifierRole longtext NULL;
ALTER TABLE RightsStatementOtherRightsInformation
    MODIFY otherRightsApplicableStartDate longtext NULL,
    MODIFY otherRightsApplicableEndDate longtext NULL
    ;
ALTER TABLE RightsStatementOtherRightsDocumentationIdentifier MODIFY otherRightsDocumentationIdentifierRole longtext NULL;
ALTER TABLE RightsStatementRightsGranted
    MODIFY startDate longtext COLLATE utf8_unicode_ci NULL,
    MODIFY endDate longtext COLLATE utf8_unicode_ci NULL
    ;

-- Delete all TasksConfigs that don't have MicroServiceChainLinks pointing at them
DELETE FROM TasksConfigs USING TasksConfigs LEFT OUTER JOIN MicroServiceChainLinks ON currentTask=TasksConfigs.pk WHERE MicroServiceChainLinks.pk is NULL;
-- Delete all StandardTasksConfigs that don't have TasksConfigs pointing at them
DELETE FROM StandardTasksConfigs USING StandardTasksConfigs LEFT OUTER JOIN TasksConfigs ON taskTypePKReference=StandardTasksConfigs.pk WHERE TasksConfigs.pk is NULL;
-- /Issue 6488
