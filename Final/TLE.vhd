--Top Level by Sanyukta Kalbhor

library IEEE;
use IEEE.numeric_bit.aLL;

entity tle is
end tle;

architecture top of tle is
--components
    component mem_12d_bit is
    port(
        w_en : in bit;
        addr, data_in: in bit_vector(11 downto 0);
        data_out : out bit_vector(11 downto 0)    
    );  
    end component;
    component Memory_TB is
    port(
        w_en_TB : out bit;
        addr_TB, data_in_TB : out bit_vector(11 downto 0);
        data_from_vec, data_from_int : in bit_vector(11 downto 0)
    );
    end component; 
--signals
    signal w_en_s: bit := '0';
    signal addr_s, data_in_s, data_out_vec_s, data_out_int_s : bit_vector(11 downto 0);  
begin --instantiation
    TB_inst : Memory_TB
        port map( w_en_TB => w_en_s, addr_TB => addr_s, data_in_TB => data_in_s,
            data_from_vec => data_out_vec_s, data_from_int => data_out_int_s);
    VEC_inst : mem_12d_bit
        port map( w_en => w_en_s, addr => addr_s, data_in => data_in_s,
            data_out => data_out_vec_s);
    INT_inst : mem_12d_bit
        port map( w_en => w_en_s, addr => addr_s, data_in => data_in_s,
            data_out => data_out_int_s);      
end top; 

configuration cfg_top of tle is
    for top
        for TB_inst: Memory_TB
            use entity work.Memory_TB(TB);
        end for;
        for VEC_inst: mem_12d_bit
            use entity work.mem_12d_bit(Behavioral1);
        end for;
        for INT_inst: mem_12d_bit
            use entity work.mem_12d_bit(Behavioral2);
        end for;
    end for;
end configuration cfg_top;