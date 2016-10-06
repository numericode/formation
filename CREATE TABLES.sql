alter table addresses drop foreign key fk_addresses_id_customer_from_customers_id;
alter table orders drop foreign key fk_orders_id_customer_from_customers_id;
alter table orders drop foreign key fk_orders_id_product_from_products_id;
alter table products drop foreign key fk_products_id_vat_from_vat_id;
alter table orders_status_history drop foreign key fk_orders_sh_id_customer_from_customers_id;

drop table if exists addresses;
drop table if exists customers;
drop table if exists orders;
drop table if exists orders_status_history;
drop table if exists products;
drop table if exists vat;
drop table if exists utils;


create table addresses(
	`id` bigint(20) unsigned not null AUTO_INCREMENT,
	`address_type` enum('courrier','domicile','facturation','livraison') not null,
	`num` varchar(16) not null,
	`street` varchar(128) not null,
	`pc` varchar(5) not null,
	`city` varchar(32) null default null,
	`id_customer` bigint(20) unsigned not null,
	unique key `id`(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 default CHARSET = utf8 collate = utf8_bin;

create table customers(
	`id` bigint(20) unsigned not null AUTO_INCREMENT,
	`firstname` varchar(32) not null,
	`lastname` varchar(64) not null,
	`email` varchar(96) not null,
	`civility` enum('Madame','Monsieur') not null,
	`phone` varchar(9) null default null,
	unique key `id`(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 default CHARSET = utf8 collate = utf8_bin;

create table orders(
	`id` bigint(20) unsigned not null AUTO_INCREMENT,
	`quantity` int not null default 0,
	`id_customer` bigint(20) unsigned not null,
	`id_product` bigint(20) unsigned not null,
	`deleted` boolean not null default 0,
	`code_order` varchar(16) null default null,
	`price` float not null default 0,
	unique key `id`(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 default CHARSET = utf8 collate = utf8_bin;

create table orders_status_history (
	`id` bigint(20) unsigned not null AUTO_INCREMENT,
	`id_customer` bigint(20) unsigned not null,
	`code_order` varchar(16) null default null,
	`date` timestamp null default now(),
	`status` enum('annulée', 'en caddie','en attente de paiement', 'en préparartion', 'en cours de livraison', 'livré') null default null,
	unique key `id`(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 default CHARSET = utf8 collate = utf8_bin;

create table products(
	`id` bigint(20) unsigned not null AUTO_INCREMENT,
	`label` varchar(255) not null,
	`description` text not null,
	`ref` varchar(16) not null,
	`price` float not null default 0,
	`picture` varchar(64) null default null,
	`id_vat` bigint(20) unsigned not null,
	unique key `id`(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 default CHARSET = utf8 collate = utf8_bin;

create table vat(
	`id` bigint(20) unsigned not null AUTO_INCREMENT,
	`code` int(11) not null,
	`rate` float not null,
	`label` varchar(24) not null,
	`startdate` timestamp not null default now(),
	`enddate` timestamp null default null,
	unique key `id`(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 default CHARSET = utf8 collate = utf8_bin;

create table utils(
	`id` bigint(20) unsigned not null AUTO_INCREMENT,
	`amount` float not null,
	`label` varchar(64) not null,
	`startdate` timestamp not null default now(),
	`enddate` timestamp null default null,
	unique key `id`(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 default CHARSET = utf8 collate = utf8_bin;

alter table addresses add constraint fk_addresses_id_customer_from_customers_id foreign key (id_customer) references customers(id);
alter table orders add constraint fk_orders_id_customer_from_customers_id foreign key d_ol (id_customer) references customers(id);
alter table orders add constraint fk_orders_id_product_from_products_id foreign key id_product (id_product) references products(id);
alter table products add constraint fk_products_id_vat_from_vat_id foreign key id_vat (id_vat) references vat(id);
alter table orders_status_history add constraint fk_orders_sh_id_customer_from_customers_id foreign key id_customer (id_customer) references customers(id);

INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('léon', 'machin', 'leon.machin@monmail.com', 'Monsieur', '605243598');
INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('anita', 'machin', 'anita.leroy@monmail.com', 'Madame', '605225588');
INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('georges', 'roux', 'g.roux235@testmail.com', 'Monsieur', '455223366');
INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('ludivine', 'plean', 'lulu.pl@monmail.com', 'Madame', '123456789');
INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('émilie', 'leclerc', 'emy.leclerc@gmail.com', 'Madame', '987654321');
INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('tamara', 'bol', 'tamara.bol33@gmail.com', 'Madame', '987321654');
INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('laetitia', 'nini', 'leati.nini@monmaillointain.com', 'Madame', '456321987');
INSERT INTO formation.customers
(firstname, lastname, email, civility, phone)
VALUES('roger', 'fin', 'roger.fin@gmail.com', 'Monsieur', null);

INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '3ter', 'rue du mesnil', '30000', 'Nîmes', (select id from customers where lastname='machin' and firstname='léon'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '3ter', 'rue du mesnil', '30000', 'Nîmes', (select id from customers where lastname='machin' and firstname='anita'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '15', 'chemin de la tramontane', '30210', 'Marguerittes', (select id from customers where lastname='roux' and firstname='georges'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '150', 'rue de la source', '30210', 'Marguerittes', (select id from customers where lastname='leclerc' and firstname='émilie'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('facturation', '6', 'rue de la source', '30210', 'Marguerittes', (select id from customers where lastname='leclerc' and firstname='émilie'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '15', 'boulevard Pied de Nez', '30000', 'Nîmes', (select id from customers where lastname='plean' and firstname='ludivine'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '125', 'rue du chemin', '30000', 'Nîmes', (select id from customers where lastname='bol' and firstname='tamara'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '3', 'rue du circuit', '30210', 'Ledenon', (select id from customers where lastname='nini' and firstname='laetitia'));
INSERT INTO formation.addresses
(address_type, num, street, pc, city, id_customer)
VALUES('domicile', '35', 'rue d\'en haut', '30210', 'Ledenon', (select id from customers where lastname='fin' and firstname='roger'));

INSERT INTO formation.vat
(code, rate, label, startdate, enddate)
VALUES(1, 20, 'tva normale', CURRENT_TIMESTAMP, null);
INSERT INTO formation.vat
(code, rate, label, startdate, enddate)
VALUES(2, 10, 'tva intermédiaire', CURRENT_TIMESTAMP, null);
INSERT INTO formation.vat
(code, rate, label, startdate, enddate)
VALUES(3, 5.5, 'tva réduite', CURRENT_TIMESTAMP, null);
INSERT INTO formation.vat
(code, rate, label, startdate, enddate)
VALUES(4, 2.5, 'tva super réduite', CURRENT_TIMESTAMP, null);
INSERT INTO formation.vat
(code, rate, label, startdate, enddate)
VALUES(-1, 0, 'exonération tva', CURRENT_TIMESTAMP, null);

INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Table basse en chêne massif', 'Table en bois massif, dimension l 50cm * L 120cm * h 60cm', 'TB1234', 200, './pics/TB1234.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Table basse en noyer massif', 'Table en bois massif, dimension l 40cm * L 40cm * h 30cm', 'TB1235', 175.55, './pics/TB1235.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Table basse en hêtre massif', 'Table en bois massif, dimension l 50cm * L 120cm * h 60cm', 'TB1236', 99.9, './pics/TB1236.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Table basse en pin massif', 'Table en bois massif, dimension l 50cm * L 120cm * h 60cm', 'TB1237', 35.75, './pics/TB1237.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Tabouret en pin', 'Tabouret, dimension diamètre 35cm * h 60cm', 'TB1238', 35.75, './pics/TB1238.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Chaise en rotin', 'Fauteuil type colonial, diamètre 80cm * L 120cm * h 60cm', 'TB1239', 75.55, './pics/TB1239.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Plateau en bois', 'Plateau rectangulaire 20cm * 40cm', 'TB1240', 19, './pics/TB1240.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Vase coloré', 'Vase coloré différentes couleurs, diamètre 20cm * h 30cm', 'TB1241', 19, './pics/TB1241.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Bhuda stone', 'Statuette en pierre à l\'effigie d\'un boudha', 'TB1242', 22.15, './pics/TB1242.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Set de sous-verres', 'Sous verres rectangulaires 10 pièces 10cm * 10cm', 'TB1243', 1, './pics/TB1243.jpg', 3);
INSERT INTO formation.products
(label, description, `ref`, price, picture, id_vat)
VALUES('Verre coloré', 'Set de 6 verres colorés', 'TB1244', 6, './pics/TB1244.jpg', 3);

INSERT INTO formation.utils
(amount, label, startdate, enddate)
VALUES(10, 'frais de port', CURRENT_TIMESTAMP, null);
