PGDMP         .                 y            infocotidiano    13.1    13.1     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16394    infocotidiano    DATABASE     m   CREATE DATABASE infocotidiano WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE infocotidiano;
                postgres    false            �          0    16397    cliente 
   TABLE DATA           9   COPY public.cliente (codigo, nome, telefone) FROM stdin;
    public          postgres    false    201   �       �           0    0    cliente_codigo_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.cliente_codigo_seq', 8, true);
          public          postgres    false    200            �   \   x��9� ��c"q$�Z��	(��w���A�R��d��H�m���m��7��'R�1���׊��cT�\�AkLR�=�����     