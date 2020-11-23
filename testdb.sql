USE testdb;

DROP TABLE IF EXISTS keypairs;
DROP PROCEDURE IF EXISTS set_keypair;
DROP PROCEDURE IF EXISTS get_keypair;

CREATE TABLE keypairs (
   name  varchar(100),
   value varchar(100),
   PRIMARY KEY (name));

DELIMITER $$
CREATE PROCEDURE set_keypair (pname text, pvalue text)
BEGIN
   INSERT INTO keypairs (name, value) VALUES (pname, pvalue)
      ON DUPLICATE KEY UPDATE name = pname, value = pvalue;
END $$

CREATE PROCEDURE get_keypair (pname text)
BEGIN
   SELECT name, value FROM keypairs WHERE NAME = pname;
END $$

DELIMITER ;
