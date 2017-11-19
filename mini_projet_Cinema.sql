drop table realisateur;
drop table groupe;
drop table membre;
drop table acteur;
drop table film;

drop type groupe_t;
drop type liste_membres_t;


drop type film_t;
drop type liste_acteurs_t;

drop type liste_commentaires_nt;
drop type commentaire_nt;

drop type liste_notes_nt;
drop type note_nt;

drop type liste_cachets_nt;
drop type cachet_nt;
drop type cachet_t;

drop type acteur_t;

drop type genre_t;
drop type realisateur_t force;
drop type commentaire_t;

drop type note_t;
drop type membre_t  force;

drop type personne_t force;


create or replace type personne_t AS Object 
(
      nom VARCHAR2(30),
      prenom VARCHAR2(30),
      nationalite VARCHAR2(30),
      age NUMBER(3)

)NOT FINAL;
/


create or replace type acteur_t UNDER personne_t();
/

create or replace type liste_acteurs_t AS TABLE of ref acteur_t;
/

create or replace type genre_t AS Object
(
       nom VARCHAR2(30),
       description VARCHAR2(100)
);
/

create or replace type realisateur_t UNDER personne_t 
(
       nb_prix NUMBER(3)
);
/

create or replace type membre_t UNDER personne_t
(
       date_inscription DATE,
       email VARCHAR2(30),
       mot_de_passe VARCHAR2(30),
       type_membre VARCHAR2(30)
);
/

-- Pour pouvoir manipuler des references on rajoute of ref 

create or replace type liste_membres_t AS TABLE of ref membre_t;
/

create or replace type groupe_t AS Object 
(
       nom VARCHAR2(30),
       description VARCHAR2(100),
       liste_membres liste_membres_t
);
/

create or replace type commentaire_t AS Object 
(
       date_commentaire DATE,
       libelle VARCHAR2(100)
);
/

create or replace type commentaire_nt AS Object 
(
       commentaire commentaire_t,
       membre ref membre_t
);
/

create or replace type liste_commentaires_nt AS TABLE of commentaire_nt;
/

create or replace type note_t AS Object
(
       valeur NUMBER(1)
);
/

create or replace type note_nt AS Object
(
       note note_t,
       membre ref membre_t
);
/

create or replace type liste_notes_nt AS TABLE of note_nt;
/

create or replace type cachet_t AS Object
(
       prix NUMBER(10)
);
/

create or replace type cachet_nt AS Object 
(
       cachet cachet_t,
       acteur ref acteur_t
);
/

create or replace type liste_cachets_nt  AS TABLE of cachet_nt;
/


create or replace type film_t AS Object 
(
       titre VARCHAR2(30),
       annee_sortie DATE, 
       pays VARCHAR2(30),
       nb_spectateurs NUMBER(10),
       genre genre_t,
       realisateur ref realisateur_t,
       liste_acteurs liste_acteurs_t,
       liste_commentaires liste_commentaires_nt,
       liste_notes liste_notes_nt,
       liste_cachets liste_cachets_nt

);
/



create table film of film_t
(
       CONSTRAINT pk_film PRIMARY KEY (titre, annee_sortie)
)
       NESTED TABLE liste_acteurs STORE AS Tab_acteurs,
       NESTED TABLE liste_commentaires STORE AS Tab_commentaires,
       NESTED TABLE liste_notes STORE AS Tab_notes,
       NESTED TABLE liste_cachets STORE AS Tab_cachets;

create table acteur of acteur_t
(
       CONSTRAINT pk_acteur PRIMARY KEY (nom, prenom, age, nationalite)
);


create table membre of membre_t 
(
       CONSTRAINT pk_membre PRIMARY KEY (email)
); 

create table groupe of groupe_t
(
       CONSTRAINT pk_groupe PRIMARY KEY (nom)
)
       NESTED TABLE liste_membres STORE AS Tab_membres;


create table realisateur of realisateur_t
(
       CONSTRAINT pk_realisateur PRIMARY KEY (nom, prenom, age, nationalite)
);


-- ########################## Insertions dans realisateur ###########################

INSERT INTO realisateur 
VALUES ('beson','luc',  'francais', 42, 4); 

INSERT INTO realisateur 
VALUES('tarantino','Quentin',  'americain', 48, 12);

INSERT INTO realisateur 
VALUES('Zemeckis','Robert',  'americain', 54, 7);

INSERT INTO realisateur 
VALUES('Darabont', 'Frank', 'americain', 39, 1);

INSERT INTO realisateur 
VALUES('Eastwood','Clint',  'americain', 34, 5);

INSERT INTO realisateur 
VALUES('Nolan','Christopher',  'britanique', 56, 3);

INSERT INTO realisateur 
VALUES('Allen','Hughes',  'americain', 27, 8);

INSERT INTO realisateur 
VALUES('Noam','Murro',  'israelien', 60, 4);

INSERT INTO realisateur 
VALUES('Debbouze', 'Jamel', 'francais', 36, 3);


-- ############################## Insertions dans membre #############################

INSERT INTO membre 
VALUES ('Diallo', 'Abdoul', 'francais', 22, to_date('07/03/2015', 'DD/MM/YYYY'), 'a@a.aa','phenix', 'admin');

INSERT INTO membre 
VALUES ('Cross', 'Ryan', 'americain', 45, to_date('08/03/2015', 'DD/MM/YYYY'),'r@r.fr','red', 'normal');

INSERT INTO membre 
VALUES ('Auzon', 'Florence', 'italien', 18, to_date('10/03/2015', 'DD/MM/YYYY'),'t@t.t','toto', 'normal');

INSERT INTO membre 
VALUES ('Antel', 'Axel', 'britanique', 35, to_date('15/03/2015', 'DD/MM/YYYY'), 'abbbbb@yyyy.hh', 'titi', 'normal');

INSERT INTO membre
VALUES ('Gadd', 'Lizzie', 'americain', 38, to_date('17/03/2015', 'DD/MM/YYYY'), 'sssssssss@ssss.ss', 'samba', 'normal');

INSERT INTO membre
VALUES ('Martinez', 'Cassandra', 'francais', 25,  to_date('19/03/2015', 'DD/MM/YYYY'), 'abbn@lll.jk', 'kasi', 'normal');

INSERT INTO membre
VALUES ('Barate', 'Thomas', 'belge', 51, to_date('31/03/2015', 'DD/MM/YYYY'), 'saliou@free.fr', 'baba', 'normal'); 


-- ############################### Insertions dans groupes #############################

INSERT INTO groupe
VALUES ('Fans du film Le livre d''eli ', 'Cette page est consacrée à ceux qui ont adorés le fameux film le livre d''eli',
        liste_membres_t ((select ref(m) from membre m where email = 'a@a.aa'),
                          (select ref(m) from membre m where email = 'r@r.fr'),
                           (select ref(m) from membre m where email = 't@t.t'))); 


INSERT INTO groupe 
VALUES ('Fans d''harry potter', 'Tous les fans d''HP',
        liste_membres_t ( (select ref(m) from membre m where email = 'abbbbb@yyyy.hh'), 
                           (select ref(m) from membre m where email = 'sssssssss@ssss.ss'),
                            (select ref(m) from membre m where email = 'saliou@free.fr'))); 


-- ############################### Insertions dans acteur #############################

INSERT INTO acteur 
VALUES ('schwarzenegger','arnold',  'americain', 50);

INSERT INTO acteur 
VALUES ('bond', 'james', 'francais', 41);

INSERT INTO acteur 
VALUES ('SAM', 'MICK', 'japonaise', 34); 

INSERT INTO acteur 
VALUES ('DiCaprio','Leonardo',  'americain', 49);

INSERT INTO acteur 
VALUES ('Hanks','Tom',  'americain', 52);

INSERT INTO acteur 
VALUES ('Wright','Robin',  'americain', 21);

INSERT INTO acteur 
VALUES ('Morse','David',  'americain', 35);

INSERT INTO acteur 
VALUES ('Vang','Bee',  'americain', 27);

INSERT INTO acteur 
VALUES ('Bale','Christian',  'britanique', 32);

INSERT INTO acteur 
VALUES ('Washington','Denzel',  'americain', 23);

INSERT INTO acteur 
VALUES ('Debbouze','Jamel',  'francais', 36);

INSERT INTO acteur 
VALUES ('Theuriau','Melissa',  'francais', 45);


-- ################################# Insertions dans films #############################

INSERT INTO film 
VALUES ('Django Unchained', to_date('16/01/2013', 'DD/MM/YYYY'),'Amerique', 200000, genre_t('action', 'action'), 
       (select ref(r) from realisateur r where nom = 'tarantino'), 
       liste_acteurs_t( (select ref(a) from acteur a where nom = 'DiCaprio'),
                        (select ref(a) from acteur a where nom = 'Bale')), 
       liste_commentaires_nt ( commentaire_nt( commentaire_t(to_date('07/03/2015', 'DD/MM/YYYY'), 'Marrant ce film, mais l''acteur est ....'), 
                                               (select ref(m) from membre m where email = 'a@a.aa'))) ,
       liste_notes_nt (note_nt( note_t(5), (select ref(m) from membre m where email = 'abbbbb@yyyy.hh'))),
       liste_cachets_nt ( cachet_nt(cachet_t (250000), (select ref(a) from acteur a where nom = 'DiCaprio')),
                          cachet_nt(cachet_t (200000), (select ref(a) from acteur a where nom = 'Bale'))));


INSERT INTO film 
VALUES ('Forest Gump', to_date('05-08-1994', 'DD/MM/YYYY'), 'Amerique', 30000, genre_t('comedie','comedie'),
        (select ref(r) from realisateur r where nom = 'Zemeckis'), 
        liste_acteurs_t( (select ref(a) from acteur a where nom = 'Hanks')),
        liste_commentaires_nt ( commentaire_nt( commentaire_t(to_date('18/03/2015', 'DD/MM/YYYY'),  'bien le film'), 
                                               (select ref(m) from membre m where email = 'r@r.fr'))) ,
       liste_notes_nt (note_nt( note_t(3), (select ref(m) from membre m where email = 'abbn@lll.jk'))),
       liste_cachets_nt ( cachet_nt(cachet_t (400000), (select ref(a) from acteur a where nom = 'Hanks'))));

INSERT INTO film 
VALUES ('le livre d''Eli', to_date('20-11-2010', 'DD/MM/YYYY'), 'Amerique', 23000, genre_t('action','action'),
        (select ref(r) from realisateur r where nom = 'Allen'), 
        liste_acteurs_t( (select ref(a) from acteur a where nom = 'Washington')),
        liste_commentaires_nt ( commentaire_nt( commentaire_t(to_date('31/03/2015', 'DD/MM/YYYY'),  'Super'), 
                                               (select ref(m) from membre m where email = 'saliou@free.fr'))) ,
       liste_notes_nt (note_nt( note_t((5)), (select ref(m) from membre m where email = 't@t.t'))),
       liste_cachets_nt ( cachet_nt(cachet_t (350000), (select ref(a) from acteur a where nom = 'Washington'))));



--  Noms des membre d'un groupe 
select deref(value(t)).nom 
from groupe g, Table(g.liste_membres) t 
where g.nom = 'Fans du film Le livre d''eli ';


-- Noms des membres n'appartenant aucun groupe 
select m.nom 
from membre m 
where m.nom not in (select deref(value(t)).nom from groupe g, Table(g.liste_membres) t ); 


-- Le top 3 des films 
select f.titre, avg(value(t).note.valeur) as note_moyenne
from film f, Table(f.liste_notes) t
where rownum < 4
group by f.titre
order by note_moyenne desc;

-- Tous les films d'un realisateur 
select f.titre
from film f
where deref(f.realisateur).nom = 'tarantino'; 

-- Films du realisateur ayant le plus de prix 
select deref(f.realisateur).nom as nom, deref(f.realisateur).nb_prix as nb_prix, f.titre 
from film f
where deref(f.realisateur).nb_prix >= all (select deref(f2.realisateur).nb_prix from film f2);

--  noms des acteurs et leur cachet dans un film
select value(c).acteur.nom, value(c).cachet.prix
from film f, Table(f.liste_cachets) c
where f.titre = 'Django Unchained'; 

-- tous les films d'un acteur
select deref(value(t)).nom as nom, f.titre
from film f, Table(f.liste_acteurs) t 
where deref(value(t)).nom = 'DiCaprio'; 


-- Tous les commentaires d'un film 
select deref(value(t).membre).nom as Nom, value(t).commentaire.libelle as Commentaire, value(t).commentaire.date_commentaire as date_comm
from film f, Table(f.liste_commentaires) t 
where f.titre = 'Forest Gump';

 -- Afficher des informations sur les tous les films
select f.titre, deref(f.realisateur).nom, f.genre.nom, f.annee_sortie, f.nb_spectateurs, f.pays 
from film f;


-- Le plus gros cachet donné a un acteur dans un film 
select value(t).cachet.prix as cachet, deref(value(t).acteur).nom as nom, f.titre
from film f, Table(f.liste_cachets) t
where value(t).cachet.prix  >= all (select value(c).cachet.prix from film f2, Table(f2.liste_cachets) c); 

