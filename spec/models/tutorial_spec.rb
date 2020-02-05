require 'rails_helper'

RSpec.describe Tutorial, type: :model do
  before(:all) do
    @original_dictionary = DocFinder.dictionary

    DocFinder.configure do |config|
      config.paths << 'spec/fixtures/config/tutorials'
      config.paths << 'spec/fixtures/_tutorials'
    end
  end

  after(:all) do
    DocFinder.dictionary = @original_dictionary
  end

  before do
    allow(described_class)
      .to receive(:task_content_path)
      .and_return('spec/fixtures/_tutorials')

    allow(described_class)
      .to receive(:tutorials_path)
      .and_return('spec/fixtures/config/tutorials')
  end

  let(:application_subtask) do
    {
      'path' => 'application/create-voice',
      'title' => 'Create a voice application',
      'is_active' => false,
      'description' => 'Learn how to create a voice application',
    }
  end

  let(:outbound_call_subtask) do
    {
      'path' => 'voice/make-outbound-call',
      'title' => 'Make an outbound call',
      'is_active' => false,
      'description' => 'Simple outbound call example',
    }
  end

  let(:introduction_subtask) do
    {
      'path' => 'introduction',
      'title' => 'Introduction Title',
      'is_active' => true,
      'description' => 'This is an introduction',
    }
  end

  let(:conclusion_subtask) do
    {
      'path' => 'conclusion',
      'title' => 'Conclusion Title',
      'is_active' => false,
      'description' => 'This is a conclusion',
    }
  end

  describe '#load' do
    it 'returns a single tutorial' do
      tutorial = described_class.load('example_tutorial', 'introduction')

      expect(tutorial).to be_kind_of(Tutorial)
      expect(tutorial.title).to eq('This is an example tutorial')
      expect(tutorial.description).to eq('Welcome to an amazing description')
      expect(tutorial.products).to eq(['demo-product'])
      expect(tutorial.subtasks).to eq([application_subtask, outbound_call_subtask])
    end

    it 'returns a tutorial with an introduction' do
      tutorial = described_class.load('with_intro', 'introduction')
      expect(tutorial.subtasks).to eq([
                                        introduction_subtask,
                                        application_subtask,
                                        outbound_call_subtask,
                                      ])
    end

    it 'returns a tutorial with a conclusion' do
      tutorial = described_class.load('with_conclusion', 'introduction')
      expect(tutorial.subtasks).to eq([
                                        application_subtask,
                                        outbound_call_subtask,
                                        conclusion_subtask,
                                      ])
    end

    it 'returns a tutorial with an introduction and a conclusion' do
      tutorial = described_class.load('with_intro_and_conclusion', 'introduction')
      expect(tutorial.subtasks).to eq([
                                        introduction_subtask,
                                        application_subtask,
                                        outbound_call_subtask,
                                        conclusion_subtask,
                                      ])
    end

    it 'returns a tutorial without tasks' do
      tutorial = described_class.load('without_tasks', 'introduction')

      expect(tutorial.title).to eq('No tutorials')
      expect(tutorial.description).to eq('Description here')
      expect(tutorial.products).to eq(['demo'])
      expect(tutorial.subtasks).to eq([])
    end
  end

  describe '#current_product' do
    it 'respects the product if provided' do
      tutorial = described_class.load('example_tutorial', 'introduction', 'banana')

      expect(tutorial.current_product).to eq('banana')
    end

    it 'defaults to the first item in the products list if not provided' do
      tutorial = described_class.load('example_tutorial', 'introduction')

      expect(tutorial.current_product).to eq('demo-product')
    end
  end

  describe '#next_step' do
    it 'returns nil if there is no next step' do
      tutorial = described_class.load('with_intro_and_conclusion', 'conclusion')

      expect(tutorial.next_step).to be_nil
    end

    it 'returns the next step after an introduction' do
      tutorial = described_class.load('with_intro_and_conclusion', 'introduction')

      expect(tutorial.next_step).to eq(application_subtask)
    end

    it 'returns the next step after a tutorial' do
      tutorial = described_class.load('with_intro_and_conclusion', 'application/create-voice')

      expect(tutorial.next_step).to eq(outbound_call_subtask)
    end
  end

  describe '#previous_step' do
    it 'returns nil if there is no previous step' do
      tutorial = described_class.load('with_intro_and_conclusion', 'introduction')

      expect(tutorial.previous_step).to be_nil
    end

    it 'returns the previous step before a conclusion' do
      tutorial = described_class.load('with_intro_and_conclusion', 'conclusion')

      expect(tutorial.previous_step).to eq(outbound_call_subtask)
    end

    it 'returns the previous step before a tutorial' do
      tutorial = described_class.load('with_intro_and_conclusion', 'voice/make-outbound-call')

      expect(tutorial.previous_step).to eq(application_subtask)
    end
  end

  describe '#first_step' do
    it 'returns introduction if it exists' do
      tutorial = described_class.load('with_intro', 'introduction')

      expect(tutorial.first_step).to eq('introduction')
    end

    it 'returns the first step if there is no introduction' do
      tutorial = described_class.load('example_tutorial', 'introduction')

      expect(tutorial.first_step).to eq('application/create-voice')
    end
  end

  describe '#content_for' do
    context 'introduction' do
      it 'returns content if it exists' do
        tutorial = described_class.load('with_intro', 'introduction')

        expect(tutorial.content_for('introduction')).to eq('Start of a tutorial')
      end

      it 'raises if it does not exist' do
        tutorial = described_class.load('example_tutorial', 'introduction')

        expect { tutorial.content_for('introduction') }.to raise_error('Invalid step: introduction')
      end
    end

    context 'conclusion' do
      it 'returns content if it exists' do
        tutorial = described_class.load('with_conclusion', 'introduction')

        expect(tutorial.content_for('conclusion')).to eq('End of a tutorial')
      end

      it 'raises if it does not exist' do
        tutorial = described_class.load('example_tutorial', 'introduction')

        expect { tutorial.content_for('conclusion') }.to raise_error('Invalid step: conclusion')
      end
    end

    context 'dynamic step' do
      it 'returns content if it exists' do
        tutorial = described_class.load('example_tutorial', 'introduction')

        expect(tutorial.content_for('application/create-voice')).to eq(<<~HEREDOC
          ---
          title: Create a voice application
          description: Learn how to create a voice application
          ---
          # Create a voice application
          Creating a voice application is very important. Please do it
        HEREDOC
                                                                   .strip + "\n")
      end

      it 'raises if it does not exist' do
        tutorial = described_class.load('example-tutorial', 'introduction')
        expect(DocFinder).to receive(:find).with(root: "#{Rails.configuration.docs_base_path}/_tutorials", document: 'missing-step', language: :en).and_call_original
      end
    end
  end
end
