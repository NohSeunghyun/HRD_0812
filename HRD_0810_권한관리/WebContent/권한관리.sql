drop table user_tbl_08; -- 존재할 시 에러나므로 미리 삭제

create table user_tbl_08 (
user_no char(5) not null primary key,
user_name varchar2(50) not null,
user_pw varchar2(50),
dept_no char(3),
user_gbn char(2),
reg_date date
);

desc user_tbl_08 -- Run Sql ~ 생성확인

--sequence 제거--
drop sequence user_tbl_08_seq;

--sequence 생성 후 사용--
create sequence user_tbl_08_seq
start with 10001
increment by 1
minvalue 10001;

insert into user_tbl_08 values (user_tbl_08_seq.nextval, '홍길동', '1111', 'A01', 'U1', '18/01/10');
insert into user_tbl_08 values (user_tbl_08_seq.nextval, '김유신', '1111', 'A02', 'U1', '18/02/10');
insert into user_tbl_08 values (user_tbl_08_seq.nextval, '이순신', '1111', null, 'U2', '18/03/10');

select * from user_tbl_08; -- insert확인

drop table dept_auth_tbl_08; -- 존재시 에러, 삭제

create table dept_auth_tbl_08 (
dept_no char(3) not null,
menu_no number not null,
primary key (dept_no, menu_no)
);

desc dept_auth_tbl_08; -- Run Sql ~ 생성확인

insert into dept_auth_tbl_08 values ('A01', 10);
insert into dept_auth_tbl_08 values ('A01', 11);
insert into dept_auth_tbl_08 values ('A02', 12);
insert into dept_auth_tbl_08 values ('A02', 13);

select * from  dept_auth_tbl_08; -- insert 확인

drop table user_auth_tbl_08 -- 존재시 에러, 삭제

create table user_auth_tbl_08 (
user_no char(5) not null,
menu_no number not null,
primary key (user_no, menu_no)
);

insert into user_auth_tbl_08 values ('10001', 12);
insert into user_auth_tbl_08 values ('10003', 13);

select * from user_auth_tbl_08; -- insert 확인

--select.jsp--
select user_no, user_name,
nvl(decode(dept_no, 'A01', '인사', 'A02', '개발', 'B01', '총무', 'B02', '회계'), ' ') as dept_no,
user_gbn, 
to_char(reg_date, 'yyyy/mm/dd')
from user_tbl_08;

--select2.jsp--
--합집합 union을 사용해야 원하는 결과값을 얻을 수 있다.
--union(합집합) : 조회한 다수의 select문을 하나로 합치고 싶을 때(중복되는 행은 하나만 표시)
--union all : 중복제거 하지않고 모두 합쳐서 보여줌
--★union을 사용하려면 조회한 select문들의 조회할 컬럼의 개수가 같아야하고 각 컬럼의 데이터타입이 같아야 함.
select user_no, user_name, menu_no,
decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산')
from user_tbl_08 natural join dept_auth_tbl_08
union
select user_no, user_name, menu_no,
decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산')
from user_tbl_08 natural join user_auth_tbl_08
order by 1 , 4 desc;

--+차집합 (minus), 교집합(intersect)--
--차집합(minus)
--(예) {도서를 주문하지 않은 고객}={모든 고객}-{도서를 주문한 고객}
select name
from customer
minus
select name
from customer
where custid in (select custid
				 from orders);

--(full/left/right)outer join ~ on : on에는 동일한 타입, 같은 의미의컬럼만
select u.dept_no, user_no, user_name, menu_no, decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산') -- 중복제거 안되기때문에 어느테이블의 컬럼인지 별칭을 사용해 적어야함
from user_tbl_08 u left outer join dept_auth_tbl_08 d -- 같은 컬럼을 구분하기위해 별칭사용해야함
on u.dept_no = d.dept_no;

select u.dept_no, user_no, user_name, menu_no, decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산') -- 중복제거 안되기때문에 어느테이블의 컬럼인지 별칭을 사용해 적어야함
from user_tbl_08 u, dept_auth_tbl_08 d -- 같은 컬럼을 구분하기위해 별칭사용해야함
where u.dept_no = d.dept_no(+);

select u.dept_no, user_no, user_name, menu_no, decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산') -- 중복제거 안되기때문에 어느테이블의 컬럼인지 별칭을 사용해 적어야함
from user_tbl_08 u right outer join dept_auth_tbl_08 d -- 같은 컬럼을 구분하기위해 별칭사용해야함
on u.dept_no = d.dept_no;

select u.dept_no, user_no, user_name, menu_no, decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산') -- 중복제거 안되기때문에 어느테이블의 컬럼인지 별칭을 사용해 적어야함
from user_tbl_08 u, dept_auth_tbl_08 d -- 같은 컬럼을 구분하기위해 별칭사용해야함
where u.dept_no(+) = d.dept_no;

select u.dept_no, user_no, user_name, menu_no, decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산') -- 중복제거 안되기때문에 어느테이블의 컬럼인지 별칭을 사용해 적어야함
from user_tbl_08 u full outer join dept_auth_tbl_08 d -- 같은 컬럼을 구분하기위해 별칭사용해야함
on u.dept_no = d.dept_no;

select u.dept_no, user_no, user_name, menu_no, decode(menu_no, '10', '부서관리', '11', '사원관리', '12', '기초정보관리', '13', '급여계산') -- 중복제거 안되기때문에 어느테이블의 컬럼인지 별칭을 사용해 적어야함
from user_tbl_08 u, dept_auth_tbl_08 d -- 같은 컬럼을 구분하기위해 별칭사용해야함
where u.dept_no(+) = d.dept_no(+); -- 오류남. full outer join은 (+)사용하면 안됨

-- 정리 - left : 왼쪽테이블의 내용은 무조건 출력 빈 컬럼은 null로 채움
--		 right : 오른쪽테이블의 내용은 무조건 출력 빈 컬럼은 null로 채움
--		 full : 모든 내용을 표시하나 빈 컬럼은 null로 채워 출력