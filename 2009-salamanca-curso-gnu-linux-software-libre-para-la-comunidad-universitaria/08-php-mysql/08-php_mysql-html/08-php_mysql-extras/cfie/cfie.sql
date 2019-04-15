-- phpMyAdmin SQL Dump
-- version 2.6.4-pl4
-- http://www.phpmyadmin.net
-- 
-- Servidor: localhost
-- Tiempo de generación: 26-01-2006 a las 17:18:36
-- Versión del servidor: 5.0.18
-- Versión de PHP: 5.1.2-1ubuntu1
-- 
-- Base de datos: `cfie`
-- 

-- --------------------------------------------------------

-- 
-- Estructura de tabla para la tabla `alumnos`
-- 

DROP TABLE IF EXISTS `alumnos`;
CREATE TABLE `alumnos` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `nombre` varchar(100) NOT NULL,
  `dni` varchar(10) NOT NULL,
  `id_tipo_de_alumno` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

-- 
-- Volcar la base de datos para la tabla `alumnos`
-- 

INSERT INTO `alumnos` (`id`, `nombre`, `dni`, `id_tipo_de_alumno`) VALUES (5, 'David Vaquero Santiago', '7977852A', 6);

-- --------------------------------------------------------

-- 
-- Estructura de tabla para la tabla `asignaturas`
-- 

DROP TABLE IF EXISTS `asignaturas`;
CREATE TABLE `asignaturas` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- 
-- Volcar la base de datos para la tabla `asignaturas`
-- 

INSERT INTO `asignaturas` (`id`, `nombre`) VALUES (3, 'afsdfsdfaasdf');
INSERT INTO `asignaturas` (`id`, `nombre`) VALUES (2, 'sdafsdfa');

-- --------------------------------------------------------

-- 
-- Estructura de tabla para la tabla `matriculas`
-- 

DROP TABLE IF EXISTS `matriculas`;
CREATE TABLE `matriculas` (
  `id_mat` int(10) unsigned NOT NULL auto_increment,
  `id_alum` int(10) unsigned NOT NULL,
  `id_asig` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id_mat`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

-- 
-- Volcar la base de datos para la tabla `matriculas`
-- 

INSERT INTO `matriculas` (`id_mat`, `id_alum`, `id_asig`) VALUES (10, 1, 3);
INSERT INTO `matriculas` (`id_mat`, `id_alum`, `id_asig`) VALUES (18, 1, 2);
INSERT INTO `matriculas` (`id_mat`, `id_alum`, `id_asig`) VALUES (16, 1, 2);
INSERT INTO `matriculas` (`id_mat`, `id_alum`, `id_asig`) VALUES (17, 1, 3);
INSERT INTO `matriculas` (`id_mat`, `id_alum`, `id_asig`) VALUES (22, 5, 2);
INSERT INTO `matriculas` (`id_mat`, `id_alum`, `id_asig`) VALUES (21, 5, 3);

-- --------------------------------------------------------

-- 
-- Estructura de tabla para la tabla `tipos_de_alumno`
-- 

DROP TABLE IF EXISTS `tipos_de_alumno`;
CREATE TABLE `tipos_de_alumno` (
  `id_tipo_de_alumno` int(11) unsigned NOT NULL auto_increment,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY  (`id_tipo_de_alumno`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

-- 
-- Volcar la base de datos para la tabla `tipos_de_alumno`
-- 

INSERT INTO `tipos_de_alumno` (`id_tipo_de_alumno`, `nombre`) VALUES (6, 'descarriado');
INSERT INTO `tipos_de_alumno` (`id_tipo_de_alumno`, `nombre`) VALUES (5, 'trasto');
INSERT INTO `tipos_de_alumno` (`id_tipo_de_alumno`, `nombre`) VALUES (4, 'aplicado');
