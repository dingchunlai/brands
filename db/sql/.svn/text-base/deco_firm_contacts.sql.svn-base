CREATE TABLE deco_firms_contacts(
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  address  VARCHAR(255) ,
  telephone VARCHAR(255),
  is_master tinyint(1) DEFAULT '0',
  online_contact VARCHAR(255),
  deco_firm_id INTEGER REFERENCES deco_firms (id) ON DELETE SET NULL,
  created_at DATETIME,  
  updated_at DATETIME 
) ENGINE InnoDB CHARACTER SET utf8;

CREATE INDEX deco_firms_contacts_deco_firm_id ON deco_firms_contacts (deco_firm_id);

