-- 변경요약 필드 추가

ALTER TABLE `TB_ISSUE_HISTORY`
	ADD (
		`EXCERPT` VARCHAR(300)        NULL DEFAULT NULL     COMMENT '변경요약' -- 변경요약
	);