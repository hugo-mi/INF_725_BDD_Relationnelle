BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "Commande" (
	"no_com"	INTEGER,
	"date_com"	DATE,
	"nom_client"	TEXT,
	PRIMARY KEY("no_com"),
	FOREIGN KEY("nom_client") REFERENCES "Client"("nom_client")
);
CREATE TABLE IF NOT EXISTS "Ligne_com" (
	"no_com"	INTEGER,
	"ref_prod"	INTEGER,
	"quantite"	INTEGER,
	PRIMARY KEY("no_com","ref_prod"),
	FOREIGN KEY("no_com") REFERENCES "Commande"("no_com"),
	FOREIGN KEY("ref_prod") REFERENCES "Produit"("ref_prod")
);
CREATE TABLE IF NOT EXISTS "Fournisseur" (
	"nom_four"	TEXT,
	"adresse_four"	TEXT,
	PRIMARY KEY("nom_four")
);
CREATE TABLE IF NOT EXISTS "Fournir" (
	"nom_four"	TEXT,
	"ref_prod"	INTEGER,
	"prix"	INTEGER,
	PRIMARY KEY("nom_four","ref_prod"),
	FOREIGN KEY("nom_four") REFERENCES "Fournisseur"("nom_four"),
	FOREIGN KEY("ref_prod") REFERENCES "Produit"("ref_prod")
);
CREATE TABLE IF NOT EXISTS "Produit" (
	"nom_prod"	TEXT,
	"ref_prod"	INTEGER,
	"no_rayon"	INTEGER,
	"prix_vente"	INTEGER,
	PRIMARY KEY("ref_prod"),
	FOREIGN KEY("no_rayon") REFERENCES "Rayon"("no_rayon")
);
CREATE TABLE IF NOT EXISTS "Employe" (
	"nom_employe"	TEXT,
	"salaire"	INTEGER,
	"no_rayon"	INTEGER,
	PRIMARY KEY("nom_employe"),
	FOREIGN KEY("no_rayon") REFERENCES "Rayon"("no_rayon")
);
CREATE TABLE IF NOT EXISTS "Rayon" (
	"nom_rayon"	TEXT,
	"no_rayon"	INTEGER,
	"chef_rayon"	TEXT,
	PRIMARY KEY("no_rayon"),
	FOREIGN KEY("chef_rayon") REFERENCES "Employe"("nom_employe")
);
CREATE TABLE IF NOT EXISTS "Client" (
	"nom_client"	TEXT,
	"adresse_client"	TEXT,
	"solde"	NUMERIC,
	PRIMARY KEY("nom_client")
);
INSERT INTO "Commande" VALUES (4,'2014-01-25','dumas');
INSERT INTO "Commande" VALUES (5,'2015-01-31','dumas');
INSERT INTO "Ligne_com" VALUES (4,8,10);
INSERT INTO "Ligne_com" VALUES (4,9,4);
INSERT INTO "Ligne_com" VALUES (5,1,2);
INSERT INTO "Ligne_com" VALUES (5,9,3);
INSERT INTO "Fournisseur" VALUES ('f1','paris');
INSERT INTO "Fournisseur" VALUES ('f2','lyon');
INSERT INTO "Fournisseur" VALUES ('f3','marseille');
INSERT INTO "Fournir" VALUES ('f1',1,90);
INSERT INTO "Fournir" VALUES ('f1',4,25);
INSERT INTO "Fournir" VALUES ('f1',5,30);
INSERT INTO "Fournir" VALUES ('f1',7,4);
INSERT INTO "Fournir" VALUES ('f2',2,70);
INSERT INTO "Fournir" VALUES ('f2',3,60);
INSERT INTO "Fournir" VALUES ('f2',6,45);
INSERT INTO "Fournir" VALUES ('f3',8,5);
INSERT INTO "Fournir" VALUES ('f3',9,32);
INSERT INTO "Produit" VALUES ('train',1,1,100);
INSERT INTO "Produit" VALUES ('avion',2,1,75);
INSERT INTO "Produit" VALUES ('bateau',3,1,70);
INSERT INTO "Produit" VALUES ('pantalon',4,2,30);
INSERT INTO "Produit" VALUES ('veste',5,2,38);
INSERT INTO "Produit" VALUES ('robe',6,2,50);
INSERT INTO "Produit" VALUES ('rateau',7,3,5);
INSERT INTO "Produit" VALUES ('pioche',8,3,7);
INSERT INTO "Produit" VALUES ('brouette',9,3,38);
INSERT INTO "Employe" VALUES ('durand',1000,1);
INSERT INTO "Employe" VALUES ('dubois',1500,1);
INSERT INTO "Employe" VALUES ('dupont',2000,1);
INSERT INTO "Employe" VALUES ('dumoulin',1200,2);
INSERT INTO "Employe" VALUES ('dutilleul',1000,2);
INSERT INTO "Employe" VALUES ('duchene',2000,2);
INSERT INTO "Employe" VALUES ('duguesclin',1500,3);
INSERT INTO "Employe" VALUES ('duduche',2000,3);
INSERT INTO "Rayon" VALUES ('jouet',1,'dupont');
INSERT INTO "Rayon" VALUES ('vetement',2,'duchene');
INSERT INTO "Rayon" VALUES ('jardin',3,'duduche');
INSERT INTO "Client" VALUES ('dupond','marseille',-300);
INSERT INTO "Client" VALUES ('dumas','lyon',1700);
CREATE TRIGGER log_patron_delete BEFORE DELETE on Commande
FOR EACH ROW
BEGIN
DELETE FROM Ligne_com
    WHERE Ligne_com.no_com = OLD.no_com;
END;
CREATE TRIGGER negative_price
   BEFORE INSERT ON Produit
BEGIN
   SELECT
      CASE
    WHEN NEW.prix_vente < 0 THEN
         RAISE (ABORT,'Invalid Price : You are trying to insert negative price')
       END;
END;
COMMIT;
