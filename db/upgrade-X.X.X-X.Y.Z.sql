--                                                                                                                     
-- PacketFence SQL schema upgrade from X.X.X to X.Y.Z
--                                                                                                                     
                                                                                                                       

--
-- Setting the major/minor/sub-minor version of the DB                                                                 
--                                                                                                                     

SET @MAJOR_VERSION = 8; 
SET @MINOR_VERSION = 1;
SET @SUBMINOR_VERSION = 9;                                                                                             
                                                                                                                       
SET @PREV_MAJOR_VERSION = 8;                                                                                           
SET @PREV_MINOR_VERSION = 1;
SET @PREV_SUBMINOR_VERSION = 0;                                                                                        
                                                                                                                       

--                                                                                                                     
-- The VERSION_INT to ensure proper ordering of the version in queries
--                                                                                                                     

SET @VERSION_INT = @MAJOR_VERSION << 16 | @MINOR_VERSION << 8 | @SUBMINOR_VERSION;                                     

SET @PREV_VERSION_INT = @PREV_MAJOR_VERSION << 16 | @PREV_MINOR_VERSION << 8 | @PREV_SUBMINOR_VERSION;                 

DROP PROCEDURE IF EXISTS ValidateVersion;                                                                              
--
-- Updating to current version
--  
DELIMITER //
CREATE PROCEDURE ValidateVersion()
BEGIN                                                                                                                  
    DECLARE PREVIOUS_VERSION int(11);
    DECLARE PREVIOUS_VERSION_STRING varchar(11);
    DECLARE _message varchar(255);
    SELECT id, version INTO PREVIOUS_VERSION, PREVIOUS_VERSION_STRING FROM pf_version ORDER BY id DESC LIMIT 1;        
              
      IF PREVIOUS_VERSION != @PREV_VERSION_INT THEN                                                                    
        SELECT CONCAT('PREVIOUS VERSION ', PREVIOUS_VERSION_STRING, ' DOES NOT MATCH ', CONCAT_WS('.', @PREV_MAJOR_VERSION, @PREV_MINOR_VERSION, @PREV_SUBMINOR_VERSION)) INTO _message;
        SIGNAL SQLSTATE VALUE '99999'                                                                                  
              SET MESSAGE_TEXT = _message;                                                                             
      END IF;                                                                                                          
END
//                                                                                                                     

DELIMITER ;                                                                                                            
call ValidateVersion;                                                                                                  
DROP PROCEDURE IF EXISTS ValidateVersion;

--
-- Increase node bandwidth_balance
--
ALTER TABLE `node` MODIFY `bandwidth_balance` bigint(20) unsigned DEFAULT NULL;

--
-- Updating locationlog
--
UPDATE locationlog set connection_type = "Ethernet-NoEAP" where connection_type = "WIRED_MAC_AUTH";

--
-- Adjust the pf_version engine so its synchronized in a cluster
--
ALTER TABLE pf_version engine = InnoDB;
    
--
-- Add other canadian SMS carriers
--

INSERT INTO sms_carrier VALUES(100122, 'Koodo Mobile', '%s@msg.koodomobile.com', now(), now());
INSERT INTO sms_carrier VALUES(100123, 'Chatr', '%s@pcs.rogers.com', now(), now());
INSERT INTO sms_carrier VALUES(100124, 'Eastlink', '%s@txt.eastlink.ca', now(), now());
INSERT INTO sms_carrier VALUES(100125, 'Freedom', 'txt.freedommobile.ca', now(), now());
INSERT INTO sms_carrier VALUES(100126, 'PC Mobile', '%s@msg.telus.com', now(), now());
INSERT INTO sms_carrier VALUES(100127, 'TBayTel', '%s@pcs.rogers.com', now(), now());

--
-- Add Freeradius decode procedure
-- 
DELIMITER $$
DROP FUNCTION IF EXISTS FREERADIUS_DECODE $$
CREATE FUNCTION FREERADIUS_DECODE (str text) 
RETURNS text
DETERMINISTIC
BEGIN 
    DECLARE result text;
    DECLARE ind INT DEFAULT 0;

    SET result = str;
    WHILE ind <= 255 DO
       SET result = REPLACE(result, CONCAT('=', LPAD(LOWER(HEX(ind)), 2, 0)), CHAR(ind));
       SET result = REPLACE(result, CONCAT('=', LPAD(HEX(ind), 2, 0)), CHAR(ind));
       SET ind = ind + 1;
    END WHILE;

    RETURN result;
END$$
DELIMITER ;

--
-- Table structure for table `key_value_storage`
--

CREATE TABLE key_value_storage (
  id VARCHAR(255),
  value BLOB,
  PRIMARY KEY(id)
) ENGINE=InnoDB;

--
-- Drop deprecated table api_user
--
DROP table api_user;

--
-- Add potd column in person table
--

ALTER TABLE person
    ADD `potd` enum('no','yes') NOT NULL DEFAULT 'no';

--
-- Updated freeradius acct_stop procedure
--

DROP PROCEDURE IF EXISTS acct_stop;
DELIMITER /
CREATE PROCEDURE acct_stop (
  IN p_timestamp datetime,
  IN p_framedipaddress varchar(15),
  IN p_acctsessiontime int(12),
  IN p_acctinputoctets bigint(20),
  IN p_acctoutputoctets bigint(20),
  IN p_acctuniqueid varchar(32),
  IN p_acctsessionid varchar(64),
  IN p_username varchar(64),
  IN p_realm varchar(64),
  IN p_nasipaddress varchar(15),
  IN p_nasportid varchar(32),
  IN p_nasporttype varchar(32),
  IN p_acctauthentic varchar(32),
  IN p_connectinfo_stop varchar(50),
  IN p_calledstationid varchar(50),
  IN p_callingstationid varchar(50),
  IN p_servicetype varchar(32),
  IN p_framedprotocol varchar(32),
  IN p_acctterminatecause varchar(12),
  IN p_acctstatustype varchar(25),
  IN p_tenant_id int
)
BEGIN
  DECLARE Previous_Input_Octets bigint(20);
  DECLARE Previous_Output_Octets bigint(20);
  DECLARE Previous_Session_Time int(12);

  # Collect traffic previous values in the radacct table
  SELECT acctinputoctets, acctoutputoctets, acctsessiontime
    INTO Previous_Input_Octets, Previous_Output_Octets, Previous_Session_Time
    FROM radacct
    WHERE acctuniqueid = p_acctuniqueid
    AND (acctstoptime IS NULL OR acctstoptime = 0) LIMIT 1;

  # Set values to 0 when no previous records
  IF (Previous_Session_Time IS NOT NULL) THEN
    # Update record with new traffic
    UPDATE radacct SET
      acctstoptime = p_timestamp,
      acctsessiontime = p_acctsessiontime,
      acctinputoctets = p_acctinputoctets,
      acctoutputoctets = p_acctoutputoctets,
      acctterminatecause = p_acctterminatecause,
      connectinfo_stop = p_connectinfo_stop
      WHERE acctuniqueid = p_acctuniqueid
      AND (acctstoptime IS NULL OR acctstoptime = 0);

    # Create new record in the log table
    INSERT INTO radacct_log
     (acctsessionid, username, nasipaddress,
      timestamp, acctstatustype, acctinputoctets, acctoutputoctets, acctsessiontime, acctuniqueid, tenant_id)
    VALUES
     (p_acctsessionid, p_username, p_nasipaddress,
     p_timestamp, p_acctstatustype, (p_acctinputoctets - Previous_Input_Octets), (p_acctoutputoctets - Previous_Output_Octets),
     (p_acctsessiontime - Previous_Session_Time), p_acctuniqueid, p_tenant_id);
  END IF;
END /
DELIMITER ;


INSERT INTO pf_version (id, version) VALUES (@VERSION_INT, CONCAT_WS('.', @MAJOR_VERSION, @MINOR_VERSION, @SUBMINOR_VERSION)); 
