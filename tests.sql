–ACTUALIZACIÓN FILA CUALQUIERA (10 iteraciones/searchk = 'M3867FZK78368IU//10):
declare
  begin
  UPDATE tracks
  set lyrics = dbms_random.string('a',dbms_random.value(900,1200))
  where searchk= 'M3867FZK78368IU//10'; 
  pkg_costes.run_test(10);
  end;
  /

–CONSULTA 1 (10 iteraciones):
declare
  begin
FOR fila in (
WITH authors as (select title,writer, writer musician from songs
 UNION select title,writer,cowriter musician from songs),
 authorship as (select distinct band performer, title, writer, 1 flag
 FROM involvement join authors using(musician) ),
 recordings as (select performer,tracks.title,writer
 from albums join tracks using(pair)),
 recs_match as (select performer,
 round(sum(flag)*100/count('c'),2) pct_recs
 from recordings left join authorship
 using(performer,title,writer)
 group by performer),
 pers_match as (select performer,
 round(sum(flag)*100/count('c'),2) pct_pers
 from (select performer, songtitle title,
 songwriter writer
 from performances) P
 left join authorship
 using(performer,title,writer)
 group by performer)
SELECT performer, pct_recs, pct_pers
 from recs_match full join pers_match using(performer)
) LOOP null; END LOOP; 
  pkg_costes.run_test(10);
  end;
  /


–CONSULTA 2 (10 iteraciones):
declare
  begin
  FOR fila in (
WITH recordings as (select performer,tracks.title, writer, min(rec_date) rec, 1 token from albums join tracks using(pair) 
group by performer,tracks.title,writer), playbacks as (select P.performer, sum(token)*100/count('x') percentage,
avg(nvl2(rec,when-rec,rec)) as age FROM performances P left join recordings R on(P.performer=R.performer
 AND R.title=P.songtitle
 AND R.writer=P.songwriter
 AND P.when>R.rec)
 GROUP BY P.performer
 ORDER BY percentage desc)
SELECT performer, percentage, floor(age/365.2422) years,
 floor(mod(age,365.2422)/30.43685) months,
 floor(mod(age,365.2422)-
(floor(mod(age,365.2422)/30.43685)*30.43685)) days
 FROM playbacks WHERE rownum<=10
) LOOP null; END LOOP;
  pkg_costes.run_test(10);
  end;
  /
