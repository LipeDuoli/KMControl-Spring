insert into Role(role, nome) values("ROLE_ADMIN","Administrador");
insert into Role(role, nome) values("ROLE_SUP","Supervisor");
insert into Role(role, nome) values("ROLE_TEC","Técnico");
insert into Usuario (id, nome, password, username) values (1, "Admin", "$2a$10$HIFU5CluG6V9aIuBvyQaLuB1caokzsecWbRibH0/z1S3NJjIycSmm", "admin");
insert into Usuario_Role (Usuario_id, roles_role) values (1, "ROLE_ADMIN");