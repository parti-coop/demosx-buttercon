-- 변경요약 필드 추가

ALTER TABLE `TB_ISSUE`
	ADD (
		`TEAM` VARCHAR(300)        NULL DEFAULT NULL     COMMENT '문화살롱 팀 이름'
	);