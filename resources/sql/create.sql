CREATE TABLE `access_point` ( 
    `ap_id` int(2) NOT NULL AUTO_INCREMENT,
    `ap_name` varchar(50) NOT NULL,
    `ap_species` varchar(50) NOT NULL,
    `ap_image` varchar(50) NOT NULL,
    `ap_radio_enabled` boolean NOT NULL,
    `ap_standard` varchar(50) NOT NULL,
    `ap_power` varchar(50) NOT NULL,
    `ap_range` int(10) NOT NULL,
    `ap_channel` varchar(50) NOT NULL,
    `ap_mac_address` varchar(50) NOT NULL,
    `ap_ssid` varchar(50) NOT NULL,
    `ap_40mhz_channels` varchar(50),
    `ap_secondary_channel` varchar(50),
    `ap_spatial_streams` varchar(50) NOT NULL,
    `ap_short_gi` boolean NOT NULL,
    `ap_greenfield` boolean NOT NULL,
    `ap_type` varchar(50),
    `ap_rotation` varchar(50),
    `ap_elevation` varchar(50),
    PRIMARY KEY (`ap_id`)
);


Insert Into `access_point` (`ap_name`, `ap_species`, `ap_image`, `ap_radio_enabled`, `ap_standard`, `ap_power`, `ap_range`, `ap_channel`, `ap_mac_address`, `ap_ssid`, `ap_40mhz_channels`, `ap_secondary_channel`, `ap_spatial_streams`, `ap_short_gi`, `ap_greenfield`, `ap_type`, `ap_rotation`, `ap_elevation`) 
                    VALUES ('IWF310', 'all', 'IWF310_S.png', 0, '802.11n', '17 dBm / 50 mW', 20, '3', 'FF:FF:FF:00:00:0A', 'SSID 3', 0, 0, 2, 1, 1, 'Generic Omni 2.2 dBi', 0, 0)
                        , ('IWF300', 'all', 'IWF300_S.png', 0, '802.11n', '17 dBm / 50 mW', 50, '4', 'FF:AB:CC:00:00:3F', 'SSID 4', 0, 0, 2, 1, 0, 'Generic Omni 2.2 dBi', 0, 0)
                        , ('IWF503', 'all', 'IWF503_S.png', 0, '802.11n', '17 dBm / 50 mW', 100, '7', 'FF:AB:CC:00:00:4F', 'SSID 7', 0, 0, 2, 1, 0, 'Generic Omni 2.2 dBi', 0, 0)
                        , ('IWF504', 'all', 'IWF504D_S.png', 0, '802.11n', '17 dBm / 50 mW', 120, '8', 'FF:AB:CC:00:00:5F', 'SSID 8', 0, 0, 2, 1, 0, 'Generic Omni 2.2 dBi', 0, 0)
                        , ('NI051', 'uplinkpoint', 'NIO51_S.png', 0, '802.11n', '17 dBm / 50 mW', 30, '5', 'GG:AA:AA:11:00:7A', 'SSID 5', 0, 0, 2, 0, 0, 'Generic Omni 2.2 dBi', 0, 0)
                        , ('NI0200', 'uplinkpoint', 'NIO200_S.png', 0, '802.11n', '17 dBm / 50 mW', 35, '2', 'GG:AA:AA:11:00:7B', 'SSID 2', 0, 0, 2, 0, 0, 'Generic Omni 2.2 dBi', 0, 0);
-- Insert Into `access_point` (`ap_name`, `ap_radio_enabled`, `ap_standard`, `ap_power`, `ap_channel`, `ap_mac_address`, `ap_ssid`, `ap_40mhz_channels`, `ap_secondary_channel`, `ap_spatial_streams`, `ap_short_gi`, `ap_greenfield`) 
--                     VALUES ('aaa', 0, 'aaa', 'aaa', 'aaa', 'aaa', 'aaa', 'aaa', 'aaa', 'aaa', 0, 0);

CREATE TABLE `account` ( 
    `a_id` int(2) NOT NULL AUTO_INCREMENT,
    `a_role` varchar(10) NOT NULL,
    `a_account` varchar(50) NOT NULL,
    `a_password` varchar(50) NOT NULL,
    `a_name` varchar(50) NOT NULL,
    `a_last_datetime` datetime,
    `a_create_datetime` datetime,
    PRIMARY KEY (`a_id`)
);

CREATE TABLE `authenticate` ( 
    `au_id` int(10) NOT NULL AUTO_INCREMENT,
    `au_a_id` int(2) NOT NULL,
    `au_token` varchar(20) NOT NULL,
    `au_effect_datetime` datetime,
    PRIMARY KEY (`au_id`)
);

CREATE TABLE `wall` ( 
    `w_id` int(2) NOT NULL,
    `w_name` varchar(50) NOT NULL,
    `w_attenuation_factor` varchar(50) NOT NULL,
    `w_last_update_datetime` datetime,
    `w_create_datetime` datetime,
    PRIMARY KEY (`w_id`)
);

Insert Into `wall` (`w_id`, `w_name`, `w_attenuation_factor`, `w_last_update_datetime`, `w_create_datetime`, `w_color_rgb`) 
                    VALUES (0, 'Metal', 20, '2018-01-01 01:01:01', '2018-01-01 01:01:01', '888888')
                        , (1, 'Glass', 3, '2018-01-01 01:01:01', '2018-01-01 01:01:01', '009FCC')
                        , (2, 'Cubicle', 10, '2018-01-01 01:01:01', '2018-01-01 01:01:01', 'DDAA00')
                        , (3, 'Brick', 12, '2018-01-01 01:01:01', '2018-01-01 01:01:01', '880000')
                        , (4, 'Concrete', 12, '2018-01-01 01:01:01', '2018-01-01 01:01:01', '666666')
                        , (5, 'Wood', 5, '2018-01-01 01:01:01', '2018-01-01 01:01:01', '8D4813')
                        , (6, 'Water', 2, '2018-01-01 01:01:01', '2018-01-01 01:01:01', '227700');
-- (Silver) (Blue) (Yellow) (Red) (Gray) (Browm) (Green)

CREATE TABLE `ip` (
    `ip_id` int(10) NOT NULL AUTO_INCREMENT,
    `ip_value` varchar(50) NOT NULL,
    `ip_page` varchar(200) NOT NULL,
    `ip_create_datetime` datetime,
    PRIMARY KEY (`ip_id`)
);

