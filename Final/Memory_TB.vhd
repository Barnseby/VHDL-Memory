--Testbench by Lara Straßberger

library IEEE;
use IEEE.numeric_bit.all;

entity Memory_TB is --TB needs ports for top level to connect it
    port(
        w_en_TB : out bit;
        addr_TB : out bit_vector(11 downto 0);
        data_in_TB : out bit_vector(11 downto 0);
        data_from_vec : in bit_vector(11 downto 0);
        data_from_int : in bit_vector(11 downto 0)
    );
end Memory_TB;

architecture TB of Memory_TB is
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
        w_en_s <= '0'; 
        wait for 1 ns; --might not be enough!!
        assert data_vec_s = data_int_s
        report "Vector memory output does not match Integer memory output at" & to_string(addr_c);
    end memory_read;
begin   
    process
    begin
        for addr_v in 0 to 4095 loop --writes each address value in respective memory cell
            memory_write(addr_v,addr_v, data_in_TB,addr_TB,w_en_TB); --(data_c, addr_c, data_in_s, addr_s, w_en_s)
        end loop;
        for addr_v in 0 to 4095 loop --reads and compares each memory cell
            memory_read(addr_v, addr_TB, w_en_TB,data_from_vec, data_from_int); --(addr_c, addr_s, w_en_s,data_vec_s,data_int_s)
        end loop;
        for addr_v in 0 to 4095 loop --clear all memory cells
            memory_write(0,addr_v, data_in_TB,addr_TB,w_en_TB);
        end loop;
        wait; --process is only executed once
    end process;
end TB;
