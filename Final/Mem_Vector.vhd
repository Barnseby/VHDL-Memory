--Vector Memory by Lemar Abawi
--Integer Memory by Laurence Sajuk

library IEEE;
use IEEE.numeric_bit.ALL; 

entity mem_12d_bit is
    Port ( 
        w_en     : in  bit;
        addr     : in  bit_vector (11 downto 0);
        data_in  : in  bit_vector (11 downto 0);
        data_out : out bit_vector (11 downto 0)
    );
end mem_12d_bit;

--Vector Memory
architecture Behavioral1 of mem_12d_bit is
begin
    process( w_en, addr, data_in )
        -- A 12-dimensional array: Each bit of the address is its own dimension
        type mem_type is array (
            bit, bit, bit, bit, bit, bit, 
            bit, bit, bit, bit, bit, bit
        ) of bit_vector( 11 downto 0 );
        
        variable Mem : mem_type;
    begin
        -- Write
        if w_en = '1' then
            -- Accessing the memory
            Mem(addr(11), addr(10), addr(9), addr(8), 
                addr(7), addr(6), addr(5), addr(4), 
                addr(3), addr(2), addr(1), addr(0)) := data_in;
        end if;

        -- Read
        data_out <= Mem(addr(11), addr(10), addr(9), addr(8), 
                        addr(7), addr(6), addr(5), addr(4), 
                        addr(3), addr(2), addr(1), addr(0));
    end process;
    
    
    
end Behavioral1;

--Integer Memory
architecture Behavioral2 of mem_12d_bit is
begin


process( w_en , addr , data_in )
   
    type mem_type is array (natural range 0 to 4095) of bit_vector( 11 downto 0 );
    variable addr_nat : natural;
    variable Mem : mem_type;
    
begin
    addr_nat := to_integer(UNSIGNED(addr)); 
    if w_en = '1' then
        Mem(addr_nat) := data_in;
    end if;
    data_out <= Mem(addr_nat);
    
end process;

end Behavioral2;
