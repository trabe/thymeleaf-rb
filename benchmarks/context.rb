require 'ostruct'

class Context
  def items
    {
        a: 'class_name1',
        'b' => 'class_name2',
        truthy: true,
        title: 'The page title oh my god!',
        products: [
            OpenStruct.new({ name: "p1", price: 0.5, categories: ['cat1', 'cat2'] }),
            OpenStruct.new({ name: "p2", price: 0.6, categories: [] })
        ]
    }
  end
end