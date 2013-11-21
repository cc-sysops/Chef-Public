class IPTablesChain
    attr_reader :name
    attr_accessor :policy, :rules

    def initialize name
        @name = name
        # the "undefined" policy for iptables
        @policy = '-'
        @rules =  []
    end

    def add_rule rule
        @rules << rule
    end

end

class IPTablesTable
    attr_reader :name

    def initialize name
        @name = name
        @chains = {}
    end

    def chains
        @chains.values
    end

    def get_chain chain_name
        @chains[chain_name] = IPTablesChain.new chain_name unless @chains.has_key? chain_name
        @chains[chain_name]
    end

end

class IPTablesConfig

    def initialize
        @tables = {}
    end

    def add_policy policy
        get_table(policy.table).get_chain(policy.chain).policy = policy.policy
    end

    def add_rule rule
        get_table(rule.table).get_chain(rule.chain).add_rule(rule)
    end

    def tables
        @tables.values
    end

    private

    def get_table table_name
        @tables[table_name] = IPTablesTable.new table_name unless @tables.has_key? table_name
        @tables[table_name]
    end

end
