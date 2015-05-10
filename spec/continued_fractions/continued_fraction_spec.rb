require File.join(File.dirname(__FILE__), "/../spec_helper")

describe ContinuedFraction do
  let(:cf) { described_class.new(number,10) }
  let(:number) { rand }
  
  it "returns an array of convergents" do
    expect(cf.convergents).to be_kind_of(Array)
  end
  
  it "preserves the number input" do
    expect(cf.number).to eq number
  end
  
  it "adds a number on the right-hand-side with a continued fraction and returns a continued fraction" do
    expect((cf + 3)).to be_kind_of(ContinuedFraction)
  end
  
  it "subtracts a number on the right-hand-side from a continued fraction and returns a continued fraction" do
    expect((cf - 3)).to be_kind_of(ContinuedFraction)
  end
  
  it "multiplies a number on the right-hand-side with a continued fraction and returns a continued fraction" do
    expect((cf * 3)).to be_kind_of(ContinuedFraction)
  end
  
  it "divides a number on the right-hand-side with a continued fraction and returns a continued fraction" do
    expect((cf / 3)).to be_kind_of(ContinuedFraction)
  end
  
  it "adds a continued fraction with another continued fraction and returns a continued fraction" do
    c = described_class.new(rand,20)
    expect((cf + c)).to be_kind_of(ContinuedFraction)
  end
  
  it "subtracts a continued fraction with another continued fraction and returns a continued fraction" do
    c = described_class.new(rand,20)
    expect((cf - c)).to be_kind_of(ContinuedFraction)
  end
  
  it "multiplies a continued fraction with another continued fraction and returns a continued fraction" do
    c = described_class.new(rand,20)
    expect((cf * c)).to be_kind_of(ContinuedFraction)
  end
  
  it "divides a continued fraction with another continued fraction and returns a continued fraction" do
    c = described_class.new(rand,20)
    expect((cf / c)).to be_kind_of(ContinuedFraction)
  end
  
  it "assigns the resulting continued fraction of a binary operation the max limit of the two operands" do
    c = described_class.new(rand,20)
    result = cf + c
    expect(result.limit).to eq [cf.limit,c.limit].max
  end
  
  context 'with irrational numbers' do
    it "should accurately calculate the convergents" do
      # First 10 convergents of PI are...
      convs = ['3/1', '22/7', '333/106', '355/113', '103993/33102', '104348/33215', '208341/66317', '312689/99532', '833719/265381', '1146408/364913'].map{|c| Rational(c)}
      cf = described_class.new(Math::PI,10)
      expect((cf.convergents_as_rationals - convs)).to be_empty
    end
    
    it "should contain convergents approaching the number" do
      0.upto(cf.convergents.length-2) do |i|
        convergent_rational_i_plus1, convergent_rational_i = cf.convergent_to_rational(cf.convergents[i+1]), cf.convergent_to_rational(cf.convergents[i])
        expect(((convergent_rational_i_plus1 - cf.number).abs <= (convergent_rational_i - cf.number).abs)).to be true
      end
    end
    
    it "should contain convergents which are expressed in lowest terms" do
      1.upto(cf.convergents.length-1) do |i|
        convergent_rational_i, convergent_rational_i_plus1 = cf.convergent_to_rational(cf.convergent(i)), cf.convergent_to_rational(cf.convergent(i+1))
        expect((convergent_rational_i.numerator*convergent_rational_i_plus1.denominator - convergent_rational_i_plus1.numerator*convergent_rational_i.denominator)).to eq (-1)**(i)
      end
    end
  end
  
  context 'with rational numbers' do
    it 'should not bomb' do
      expect {described_class.new(1.5, 10)}.to_not raise_error
    end
    
    it 'limits the number convergents' do
      expect(described_class.new(1.5, 10).limit).to be < 10
    end
  end
end