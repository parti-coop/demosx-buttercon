-- 슬랙 URL 채널 추가

ALTER TABLE `TB_ISSUE`
	ADD (
		`SLACK_URL` VARCHAR(300)        NULL DEFAULT NULL     COMMENT 'SLACK URL', -- 슬랙 URL
		`SLACK_CHANNEL` VARCHAR(100)        NULL DEFAULT NULL     COMMENT 'SLACK CHANNEL' -- 슬랙 CHANNEL
	);