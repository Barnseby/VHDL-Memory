----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Lara
-- 
-- Create Date: 25.04.2026 17:45:07
-- Design Name: 
-- Module Name: Memory_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;

entity Memory_TB is
end Memory_TB;
architecture TB of Memory_TB is
    component MEM_vector
        port ( 
            w_en_v : in bit;
            addr_v : in bit_vector (11 downto 0);
            data_in_v : in bit_vector (11 downto 0);
            data_out_v : out bit_vector (11 downto 0));
    end component;
    component MEM_integer
        port ( 
            w_en_i : in bit;
            addr_i : in bit_vector (11 downto 0);
            data_in_i : in bit_vector (11 downto 0);
            data_out_i : out bit_vector (11 downto 0));
    end component; 
--signals
    signal w_en: bit := '0';
    signal addr, data_in : bit_vector(11 downto 0);  
    signal data_out_vec, data_out_int : bit_vector(11 downto 0);
--function declarations
--write function
    procedure memory_write( 
        constant data_c : natural; 
        constant addr_c : natural; 
        signal data_in_s : out bit_vector;
        signal addr_s : out bit_vector;
        signal w_en_s : out bit 
        )is
        constant data_length : natural := data_in_s'length;
        constant addr_length : natural := addr_s'length;
    begin
        addr_s <= bit_vector(to_unsigned(addr_c,addr_length)); --sends loop iterator as vector address
        data_in_s <= bit_vector(to_unsigned(data_c,data_length)); --sends loop iterator as vector data
        w_en_s <= '1'; wait for 1 ns; w_en_s <= '0'; wait for 1 ns;
    end memory_write;
--read function
    procedure memory_read( 
        constant addr_c : natural; 
        signal addr_s : out bit_vector;
        signal w_en_s : out bit;
        signal data_vec_s : in bit_vector;
        signal data_int_s : in bit_vector
        )is
        constant addr_length : natural := addr_s'length;
    begin
        addr_s <= bit_vector(to_unsigned(addr_c,addr_length)); --sends loop iterator as vector address
        w_en_s <= '0'; wait for 1 ns; 
        assert data_vec_s = data_int_s
        report "Vector memory output does not match Integer memory output at" & to_string(addr_c);
    end memory_read;
begin
U1: MEM_vector
    port map( w_en, addr, data_in, data_out_vec);
U2: MEM_integer
    port map( w_en, addr, data_in, data_out_int);
process
begin
    for addr_v in 0 to 4095 loop --writes each address value in respective memory cell
        memory_write(addr_v,addr_v, data_in,addr,w_en); --(data_c, addr_c, data_in_s, addr_s, w_en_s)
    end loop;
    for addr_v in 0 to 4095 loop --reads and compares each memory cell
        memory_read(addr_v, addr, w_en,data_out_vec, data_out_int); --(addr_c, addr_s, w_en_s,data_vec_s,data_int_s)
        -- v v for test v v 
        assert data_out_vec = bit_vector(to_unsigned(addr_v,addr'length)); 
        -- ^ ^ delete later ^ ^
    end loop;
    wait; --process is only executed once
end process;
end TB;
