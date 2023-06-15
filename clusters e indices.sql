-- hacer drop de tracks, albums y el cluster para poder crear de nuvevo el cluster
drop table tracks;
drop table albums;
drop cluster albums_tracks;
drop index pistas;
drop index performance;


-- este cluster es de albums y tracks
create cluster albums_tracks (PAIR char(15));
CREATE TABLE ALBUMS(
PAIR       CHAR(15), 
performer  VARCHAR2(50) NOT NULL,
format     CHAR(1) NOT NULL,  -- (T)streaming (C)CD (M)Audio File (V)Vynil (S)Single 
title      VARCHAR2(50) NOT NULL,
rel_date   DATE NOT NULL,
publisher  VARCHAR2(25) NOT NULL,
manager    NUMBER(9) NOT NULL,
CONSTRAINT PK_ALBUMS PRIMARY KEY(PAIR),
CONSTRAINT UK_ALBUMS UNIQUE (performer,format,title,rel_date),
CONSTRAINT FK_ALBUMS1 FOREIGN KEY(performer) REFERENCES PERFORMERS,
CONSTRAINT FK_ALBUMS2 FOREIGN KEY(manager) REFERENCES MANAGERS,
CONSTRAINT FK_ALBUMS3 FOREIGN KEY(publisher) REFERENCES PUBLISHERS,
CONSTRAINT CK_format CHECK (format in ('T','C','M','V','S'))
) cluster albums_tracks (PAIR);

CREATE TABLE TRACKS (
PAIR      CHAR(15),
sequ      NUMBER(3) NOT NULL,
title     VARCHAR2(50) NOT NULL,
writer    CHAR(14) NOT NULL, 
duration  NUMBER(4) NOT NULL, -- in seconds
rec_date  DATE NOT NULL,
studio    VARCHAR2(50),
engineer  VARCHAR2(50) NOT NULL, 
CONSTRAINT PK_TRACKS PRIMARY KEY(PAIR, sequ), 
CONSTRAINT FK_TRACKS1 FOREIGN KEY (PAIR) REFERENCES ALBUMS  ON DELETE CASCADE,
CONSTRAINT FK_TRACKS2 FOREIGN KEY (title, writer) REFERENCES SONGS,
CONSTRAINT FK_TRACKS3 FOREIGN KEY (studio) REFERENCES STUDIOS ON DELETE SET NULL,
CONSTRAINT CK_duracion CHECK (duration<=5400) 
) cluster albums_tracks (PAIR);

create index ind_pair on cluster albums_tracks;

-- crear indice para consulta 1 en songs
create index pistas on tracks(pair, title, writer);
-- indice para performance
create index performance on performances(performer, songtitle, songwriter);
