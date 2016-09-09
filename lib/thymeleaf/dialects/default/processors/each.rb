class EachProcessor
  
  include Thymeleaf::Processor
  require_relative '../parsers/each'

  def call(node:nil, attribute:nil, context:nil, **_)
    variable, stat, enumerable = EachExpression.parse(context, attribute.value)
    
    elements = evaluate_in_context(context, enumerable)
    
    stat_var = init_stat_var(stat, elements)


    attribute.unlink
    
    elements.each do |element|
      subcontext_vars = {}
      subcontext_vars[variable] = element unless variable.nil?

      unless stat.nil?
        stat_var[:index]  += 1
        stat_var[:count]  += 1
        stat_var[:current] = element
        stat_var[:even]    = stat_var[:count].even?
        stat_var[:odd]     = stat_var[:count].odd?
        stat_var[:first]   = (stat_var[:index].eql? 0)
        stat_var[:last]    = (stat_var[:count].eql? stat_var[:size])

        subcontext_vars[stat] = stat_var
      end
      
      subcontext = ContextHolder.new(subcontext_vars, context)
      new_node = node.dup
      subprocess_node(subcontext, new_node)
      node.add_previous_sibling(new_node)
    end

    node.children.each {|child| child.unlink }
    node.unlink
    
    context # TODO: Remove
  end
  
  def has_subcontext?
    true
  end

private

  def init_stat_var(stat, elements)
    if stat.nil?
      nil
    else
      {
          :index    => -1,
          :count    => 0,
          :size     => elements.length,
          :current  => nil,
          :even     => false,
          :odd      => true,
          :first    => true,
          :last     => false
      }
    end
  end
  
end