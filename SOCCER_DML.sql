﻿--SQL_TEST_001

SELECT count(*) "테이블의 수"
FROM tab;


--SQL_TEST_002

SELECT team_name "전체 축구팀 목록" 
FROM team 
order by team_name;


--SQL_TEST_003

SELECT DISTINCT NVL2(position,position,'신입') 포지션 
FROM player;


--SQL_TEST_004  수원팀(ID :K02) 골키퍼

SELECT player_name 이름
FROM player
WHERE team_id like'K02' and position like'GK'
ORDER BY player_name;


SELECT player_name 이름
FROM player
WHERE team_id like (SELECT team_id
                    FROM team
                    WHERE team_name like '삼성블루윙즈') 
    and position like'GK'
ORDER BY player_name;


-- SQL_TEST_005 : 수원팀(ID: K02) && 키가 170 이상 선수 && 성이 고씨

SELECT position 포지션, player_name 이름
FROM player
WHERE team_id like'K02' 
    and height>=170 
    and substr(player_name,0,1) like'고';
    
SELECT position 포지션, player_name 이름
FROM player
WHERE team_id like'K02' 
    and height>=170 
    and player_name like'고__';

SELECT position 포지션, player_name 이름
FROM player
WHERE team_id like'K02' 
    and height>=170 
    and player_name like'고%';

SELECT position 포지션, player_name 이름
FROM player
WHERE team_id like'K02' 
    and height>=170 
    and player_name like'%운%';

SELECT position 포지션, player_name 이름
FROM player
WHERE team_id like (SELECT team_id
                    FROM team
                    WHERE team_name like '삼성블루윙즈') 
    and height>=170 
    and substr(player_name,0,1) like'고'
 ;


-- SCCOER_SQL_006
-- 수원팀(ID: K02) 선수들 이름,
-- 키와 몸무게 리스트 (단위 cm 와 kg 삽입)
-- 키와 몸무게가 없으면 "0" 표시
-- 키 내림차순

SELECT 
    player_name || '선수' 이름, 
    NVL2(height,height,0) ||'cm' 키, 
    NVL2(weight,weight,0) ||'kg' 몸무게
FROM player
WHERE team_id like 'K02'
ORDER BY height DESC
;


SELECT 
    player_name || '선수' 이름, 
    NVL2(height,height,0) ||'cm' 키, 
    NVL2(weight,weight,0) ||'kg' 몸무게
FROM player
WHERE team_id like (SELECT team_id
                    FROM team
                    WHERE team_name like '삼성블루윙즈')
ORDER BY height DESC
;


-- SQL_TEST_007
-- 수원팀(ID: K02) 선수들 이름,
-- 키와 몸무게 리스트 (단위 cm 와 kg 삽입)
-- 키와 몸무게가 없으면 "0" 표시
-- BMI지수 
-- 키 내림차순BMI = 몸무게 / 키² 로서, 여기서 몸무게는 kg, 키는 m 단위이다. 예를 들자면, 몸무게 55kg에 키 1.68m인 사람의 BMI는 
--  55kg/(1.68m)^2 = 19.4이다

SELECT 
    player_name || '선수' 이름, 
    NVL2(height,height,0) ||'cm' 키, 
    NVL2(weight,weight,0) ||'kg' 몸무게, 
    round((weight/(height*height)*10000),2) BMI비만지수
FROM player
WHERE team_id like (
                    SELECT team_id
                    FROM team
                    WHERE team_name like '삼성블루윙즈')
ORDER BY height DESC
;


-- SOCCER_SQL_008 
-- 수원팀(ID: K02) 과 대전팀(ID: K10)선수들 중 이
-- GK 포지션인 선수
-- 팀명 사람명 오름차순

SELECT t.team_name, p.position, p.player_name
FROM player p, team t
WHERE p.team_id = t.team_id
        AND p.team_id in('K02','K10') 
        AND p.position like 'GK'
ORDER BY t.team_name, p.player_name
;

--ANSI
SELECT 
    t.team_name, 
    p.position, 
    p.player_name
FROM player p 
    JOIN team t  
        ON p.team_id like t.team_id
WHERE p.team_id in('K02','K10') 
   AND p.position like 'GK'
ORDER BY t.team_name, p.player_name
;


SELECT 
    t.team_name, 
    p.position, 
    p.player_name
FROM player p  
    JOIN team t  
        ON p.team_id like t.team_id
WHERE p.team_id in((SELECT team_id
                    FROM team
                    WHERE team_name IN('삼성블루윙즈','시티즌')))
    AND p.position like 'GK'
ORDER BY t.team_name, p.player_name
;


SELECT 
    t.team_name, 
    p.position, 
    p.player_name
FROM (SELECT team_id, team_name
      FROM team
      WHERE team_name IN('삼성블루윙즈','시티즌')) t, player p
WHERE p.team_id like t.team_id
    AND p.position like 'GK'
ORDER BY t.team_name, p.player_name
;

 

-- SOCCER_SQL_009 
-- 삼성블루윙즈(ID: K02) 과 시티즌(ID: K10)선수들 중 이
-- 키가 180 이상 183 이하인 선수들
-- 키, 팀명, 사람명 오름차순

SELECT p.height||'cm' 키,  t.team_name 팀명, p.player_name 이름
FROM player p, team t
WHERE p.team_id like t.team_id 
    AND p.height between 180 and 183
    AND p.team_id in('K02','K10')
ORDER BY p.height, t.team_name, p.player_name
;    


--ANSI
SELECT p.height||'cm' 키,  
       t.team_name 팀명, 
       p.player_name 이름
FROM player p
    JOIN team t
        ON p.team_id like t.team_id 
WHERE p.height between 180 and 183
    AND p.team_id in(
                      SELECT team_id
                      FROM team
                      WHERE team_name IN('삼성블루윙즈','시티즌'))
ORDER BY p.height, t.team_name, p.player_name
;


SELECT p.height||'cm' 키,  
       t.team_name 팀명, 
       p.player_name 이름
FROM (SELECT team_id, team_name
     FROM team
     WHERE team_name IN('삼성블루윙즈','시티즌')) t, player p
WHERE p.team_id like t.team_id 
    AND height between 180 and 183
ORDER BY p.height, t.team_name, p.player_name
;


--SOCCER_SQL_010
--  모든 선수들 중
-- 포지션을 배정받지 못한 선수들의 팀과 이름
-- 팀명, 사람명 오름차순

SELECT t.team_name, p.player_name
FROM player p, team t
WHERE p.team_id like t.team_id
    AND p.position IS NULL
ORDER BY t.team_name, p.player_name; 

--ANSI
SELECT t.team_name, p.player_name
FROM player p
    JOIN team t
        ON p.team_id like t.team_id
WHERE p.position IS NULL
ORDER BY t.team_name,p.player_name
;


-- SOCCER_SQL_011
--  팀과 스타디움을 조인하여
-- 팀이름, 스타디움 이름 출력

SELECT T.TEAM_NAME 팀명, 
    S.STADIUM_NAME 스타디움
FROM TEAM T
    JOIN STADIUM S
        ON T.TEAM_ID LIKE S.HOMETEAM_ID
ORDER BY T.TEAM_NAME
;

-- SOCCER_SQL_012
--  팀과 스타디움, 스케줄을 조인하여
-- 2012년 3월 17일에 열린 각 경기의 
-- 팀이름, 스타디움, 어웨이팀 이름 출력
-- 다중테이블 join 을 찾아서 해결하시오.

SELECT T.TEAM_NAME 팀명,
    S.STADIUM_NAME 스타디움, 
    SC.AWAYTEAM_ID 원정팀ID,
    SC.SCHE_DATE 스케쥴날짜  
FROM SCHEDULE SC
    JOIN TEAM T
        ON SC.HOMETEAM_ID LIKE T.TEAM_ID
    JOIN STADIUM S
        ON S.STADIUM_ID LIKE SC.STADIUM_ID
 WHERE SC.SCHE_DATE LIKE '20120317' -- 로우데이타라 '' 입력한다.
 ORDER BY T.TEAM_NAME
 ;

SELECT T.TEAM_NAME 팀명,
    S.STADIUM_NAME 스타디움, 
    SC.AWAYTEAM_ID 원정팀ID,
    SC.SCHE_DATE 스케쥴날짜  
FROM (SELECT SCHE_DATE, AWAYTEAM_ID, HOMETEAM_ID,STADIUM_ID
      FROM SCHEDULE
      WHERE SCHE_DATE LIKE '20120317') SC
    JOIN TEAM T
        ON SC.HOMETEAM_ID LIKE T.TEAM_ID
    JOIN STADIUM S
        ON S.STADIUM_ID LIKE SC.STADIUM_ID
 ORDER BY T.TEAM_NAME
 ;




-- SOCCER_SQL_013
-- 2012년 3월 17일 경기에 
-- 포항 스틸러스 소속 골키퍼(GK)
-- 선수, 포지션,팀명 (연고지포함), 
-- 스타디움, 경기날짜를 구하시오
-- 연고지와 팀이름은 간격을 띄우시오       
 

SELECT P.PLAYER_NAME 선수명,
    P.POSITION 포지션,
    T.REGION_NAME || '  ' || T.TEAM_NAME 팀명,
    S.STADIUM_NAME 스타디움,
    SC.SCHE_DATE 스케쥴날짜  
FROM 
    SCHEDULE SC
    JOIN PLAYER P
        ON P.TEAM_ID IN(SC.HOMETEAM_ID,SC.AWAYTEAM_ID)
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
    JOIN STADIUM S
        ON P.TEAM_ID LIKE S.HOMETEAM_ID
 WHERE SC.SCHE_DATE LIKE 20120317
    AND P.POSITION LIKE 'GK'
    AND T.TEAM_NAME  LIKE '스틸러스'
 ORDER BY P.PLAYER_NAME
 ;
 
 
 SELECT P.PLAYER_NAME 선수명,
    P.POSITION 포지션,
    T.REGION_NAME || '  ' || T.TEAM_NAME 팀명,
    S.STADIUM_NAME 스타디움,
    SC.SCHE_DATE 스케쥴날짜  
FROM 
    SCHEDULE SC
    JOIN PLAYER P
        ON P.TEAM_ID IN(SC.HOMETEAM_ID,SC.AWAYTEAM_ID)
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
    JOIN STADIUM S
        ON P.TEAM_ID LIKE S.HOMETEAM_ID
 WHERE SC.SCHE_DATE LIKE 20120317
    AND P.POSITION LIKE 'GK'
    AND T.TEAM_ID  LIKE
                        ( SELECT TEAM_ID
                          FROM TEAM
                          WHERE TEAM_NAME LIKE '스틸러스' )
 ORDER BY P.PLAYER_NAME
 ;
 
 
 
SELECT P.PLAYER_NAME 선수명,
    P.POSITION 포지션,
    T.REGION_NAME || '  ' || T.TEAM_NAME 팀명,
    S.STADIUM_NAME 스타디움,
    SC.SCHE_DATE 스케쥴날짜  
FROM 
    SCHEDULE SC
    JOIN PLAYER P
        ON P.TEAM_ID IN(SC.HOMETEAM_ID,SC.AWAYTEAM_ID)
    JOIN (SELECT TEAM_ID,TEAM_NAME,REGION_NAME
          FROM TEAM
          WHERE TEAM_NAME LIKE '스틸러스' ) T
        ON P.TEAM_ID LIKE T.TEAM_ID
    JOIN STADIUM S
        ON P.TEAM_ID LIKE S.HOMETEAM_ID
 WHERE SC.SCHE_DATE LIKE 20120317
    AND P.POSITION LIKE 'GK'
 ORDER BY P.PLAYER_NAME
 ;
 
 
 
        
-- SOCCER_SQL_014
-- 홈팀이 3점이상 차이로 승리한 경기의 
-- 경기장 이름, 경기 일정
-- 홈팀 이름과 원정팀 이름을
-- 구하시오

SELECT  S.STADIUM_NAME 스타디움,
    SC.SCHE_DATE 경기날짜,  
    ht.REGION_NAME || '  ' ||ht.TEAM_NAME  홈팀,
    at.REGION_NAME || '  ' ||at.TEAM_NAME  원정팀,
    SC.HOME_SCORE "홈팀 점수",
    SC.AWAY_SCORE "원정팀 점수"
 FROM 
    SCHEDULE SC
    JOIN STADIUM S
        ON SC.STADIUM_ID LIKE S.STADIUM_ID
    JOIN TEAM ht
        ON SC.HOMETEAM_ID LIKE ht.TEAM_ID
    JOIN TEAM at
        ON SC.AWAYTEAM_ID LIKE at.TEAM_ID
WHERE SC.HOME_SCORE - SC.AWAY_SCORE >= 3
ORDER BY SC.SCHE_DATE
;


-- SOCCER_SQL_015
-- STADIUM 에 등록된 운동장 중에서
-- 홈팀이 없는 경기장까지 전부 나오도록
-- 카운트 값은 20 , 일산 밑에 마산, 안양도 있음  

SELECT s.stadium_name, s.stadium_id, s.seat_count, s.hometeam_id, t.e_team_name
FROM stadium s
    LEFT JOIN team t  
        ON s.hometeam_id like t.team_id
ORDER BY s.hometeam_id
;


-- SOCCER_SQL_016
-- 소속이 삼성블루윙즈 팀인 선수들과
-- 드래곤즈팀인 선수들의 선수 정보
SELECT 
    T.TEAM_NAME 팀명,
    P.PLAYER_NAME 선수명,
    P.POSITION 포지션,
    P.BACK_NO 백넘버,
    P.HEIGHT 키
FROM PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE 
    T.TEAM_ID IN ( 'K02' , 'K07' )
;


-- SOCCER_SQL_017
-- 소속이 삼성 블루윙즈 팀인 선수들과
-- 전남 드래곤즈팀인 선수들의 선수 정보

SELECT 
    T.TEAM_NAME 팀명,
    P.PLAYER_NAME 선수명,
    P.POSITION 포지션,
    P.BACK_NO 백넘버,
    P.HEIGHT 키
FROM PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE 
    T.TEAM_ID IN (
        (SELECT TEAM_ID 
        FROM TEAM 
        WHERE TEAM_NAME 
            IN('삼성블루윙즈','드래곤즈')))
;

-- SOCCER_SQL_018
-- 최호진 선수의 소속팀과 포지션, 백넘버는 무엇입니까
SELECT t.TEAM_NAME 팀명,p.PLAYER_NAME 이름, p.BACK_NO 백넘버
FROM player p
    JOIN team t
        on p.team_id like t.team_id
WHERE p.player_name like '최호진';



-- SOCCER_SQL_019
-- 대전시티즌의 MF 평균키는 얼마입니까
SELECT ROUND(AVG(P.HEIGHT),2) 평균키 
FROM PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE P.TEAM_ID like(SELECT TEAM_ID
                     FROM TEAM
                     WHERE TEAM_NAME LIKE '시티즌')
    AND p.position like 'MF';
        
    
    
-- SOCCER_SQL_020
-- 2012년 월별 경기수를 구하시오
SELECT 
    COUNT(k3.SCHE_DATE) "3월",
    COUNT(k4.SCHE_DATE) "4월"
FROM SCHEDULE K3, SCHEDULE K4
WHERE SUBSTR(k3.SCHE_DATE,1,6) LIKE '201203'
-- or SUBSTR(k4.SCHE_DATE,1,6) LIKE '201204'
;

-- 021
-- 2012년 월별 진행된 경기수(GUBUN IS YES)를 구하시오
-- 출력은 1월:20경기 이런식으로...





-- 022
-- 2012년 9월 14일에 벌어질 경기는 어디와 어디입니까
-- 홈팀: ?   원정팀: ? 로 출력



---------------------------------------------------------------------------------

SELECT * FROM SCHEDULE ORDER BY SCHE_DATE;
SELECT * FROM PLAYER;
SELECT * FROM TEAM;
SELECT * FROM STADIUM;