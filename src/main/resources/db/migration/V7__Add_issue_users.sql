
-- 버터문서 관련자
CREATE TABLE `TB_ISSUE_MAKER` (
	`USER_ID`  BIGINT(20) UNSIGNED NOT NULL COMMENT '회원ID', -- 회원ID
	`ISSUE_ID` BIGINT(20) UNSIGNED NOT NULL COMMENT '이슈ID', -- 이슈ID
	`REG_DT`   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시', -- 등록일시
	`REG_IP`   VARCHAR(15)         NOT NULL COMMENT '등록아이피' -- 등록아이피
)
COMMENT '버터문서 관련자';

-- 버터문서 관련자 Primary key
ALTER TABLE `TB_ISSUE_MAKER`
	ADD CONSTRAINT `PK_TB_ISSUE_MAKER` -- 버터문서 관련자 Primary key
		PRIMARY KEY (
			`USER_ID`,  -- 회원ID
			`ISSUE_ID`  -- 이슈ID
		);
