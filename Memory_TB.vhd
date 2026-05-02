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
        generic( --address and data width easily changeable
            addr_width_v : positive range 1 to 31 := 12; --there is no address with zero bit
            data_width_v : positive := 16); --random default value
        port ( 
            w_en_v : in bit;
            addr_v : in bit_vector (addr_width_v-1 downto 0);
            data_in_v : in bit_vector (data_width_v-1 downto 0);
            data_out_v : out bit_vector (data_width_v-1 downto 0));
    end component;
    component MEM_integer
        generic( --address and data width easily changeable
            addr_width_i : positive range 1 to 31 := 12; --warum range ab 1?
            data_width_i : positive := 16); --warum 16?
        port ( 
            w_en_i : in bit;
            addr_i : in bit_vector (addr_width_i-1 downto 0);
            data_in_i : in bit_vector (data_width_i-1 downto 0);
            data_out_i : out bit_vector (data_width_i-1 downto 0));
    end component;
    --component MEM_integer
    --generic( --address and data width easily changeable
    --        addr_width_i : positive range 1 to 31 := 12; --warum range ab 1?
     --       data_width_i : positive := 16); --warum 16?
     --   port ( 
     --       w_en_i : in boolean;
     --       addr_i : in integer range 2**addr_width_i-1 downto 0;
     --       data_in_i : in integer range 2**addr_width_i-1 downto 0;
     --       data_out_i : out integer range 2**addr_width_i-1 downto 0);
    --end component;  
    signal w_en: bit := '0'; --initialization
    signal addr, data_in : bit_vector(11 downto 0);  
    signal data_out_vec, data_out_int : bit_vector(11 downto 0);
    --signal data_out_int : integer range 4095 downto 0; --to_integer(unsigned(vector_sg)) 
    --signal w_en_vec: bit := '0'; --(w_en = '1') 
    --signal addr_vec, data_in_vec, data_out_vec : bit_vector(11 downto 0);--data_width not declared
    --signal w_en_int: boolean;
    --signal addr_int, data_in_int, data_out_int : integer range 4095 downto 0;
    procedure memory_write( --function for write operation
        constant data_c : natural; --loop iterator
        constant addr_c : natural; --loop iterator
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
    procedure memory_read( --function for read operation
        --constant data_c : natural; --not necessary for comparison of signals from memory
        constant addr_c : natural; 
        --signal data_in_s : out bit_vector;
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
    generic map(data_width_v =>12)
    port map( w_en, addr, data_in, data_out_vec);
U2: MEM_integer
    generic map(addr_width_i => 12)
    port map( w_en, addr, data_in, data_out_int);
--U2: entity work.MEM_integer
    --generic map(data_width_i =>12)
    --port map( w_en => (w_en = '1'), addr => addr, data_in => to_integer(unsigned(data_in)),
                 --data_out => data_out_int); 
process
begin
    for addr_v in 0 to 4095 loop
        memory_write(addr_v,addr_v, data_in,addr,w_en); --(data_c, addr_c, data_in_s, addr_s, w_en_s)
    end loop;
    for addr_v in 0 to 4095 loop
        memory_read(addr_v, addr, w_en,data_out_vec, data_out_int); --(addr_c, addr_s, w_en_s,data_vec_s,data_int_s)
        assert data_out_vec = bit_vector(to_unsigned(addr_v,addr'length)); --for test >> delete later
    end loop;
    wait; --process is only executed once
end process;
end TB;
