CREATE TABLE user (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARBINARY(32) NOT NULL,

    PRIMARY KEY(id),
    UNIQUE KEY (name)
);

CREATE TABLE entry (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `title` VARBINARY(256) NOT NULL,
    `text` VARBINARY(512) NOT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    `date` DATE NOT NULL DEFAULT '0000-00-00',

    PRIMARY KEY(id),
    UNIQUE KEY(user_id, created),
    KEY (user_id, date, created)
);