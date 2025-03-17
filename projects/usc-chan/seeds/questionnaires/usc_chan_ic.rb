# frozen_string_literal: true

ic_name1 = 'usc_chan_ic'
informed_consent1 = Questionnaire.find_by(name: ic_name1)
informed_consent1 ||= Questionnaire.new(name: ic_name1)
informed_consent1.key = File.basename(__FILE__)[0...-3]
ic_content = <<~'END'
    <div style="height: calc(80dvh - 12rem); overflow-y: scroll;"> 
      <H3>
        Broad Consent for Future Research Uses of Identifiable Information
      </H3>
      <H3>Research with Private Information</H3>
      <p>
        Research using personal health information (such as information about
        your health status, and what medical conditions you have) has led to
        important advances in science and medicine. As explained in this form,
        we hope to make it easier for researchers to use your information in the
        future.
      </p>
      <p className={blockCls}>
        The rules for how information originally collected for one purpose (such
        using the vitaMAPS app to gain insights into your health) can be used
        for research depend on whether the information identifies you
        personally. When all of the details that could reasonably be used to
        identify you have been removed, we say they are “de-identified.” United
        States law allows researchers to use de-identified information without
        asking for permission.
      </p>
      <p className={blockCls}>
        When your information can still be linked to you, we say they are
        “identifiable.” Research with identifiable information can be even more
        helpful, because it allows researchers to understand even more about
        medical conditions. However, research with identifiable information
        bears more risk to people’s privacy, and therefore, there are strict
        rules for this kind of research. When researchers ask you to say “yes”
        to allow your identifiable information to be used in a wide range of
        different types of research studies in the future, this is called “broad
        consent,” and it is what we are asking you to agree to in this form.
      </p>
      <H3>What are we asking you to do?</H3>
      <p className={blockCls}>
        This form asks you to decide if you are willing to give your broad
        consent now to the future research use of your identifiable information.
        If you say “yes,” researchers in the future may use your identifiable
        information in many different research studies without asking your
        permission again for any specific study. This could help science.
      </p>
      <p className={blockCls}>
        If you say “no,” researchers will have to ask your permission to use
        your identifiable information in any future research study. Because this
        may be difficult or impossible, it could make scientific studies harder
        to do.
      </p>
      <p className={blockCls}>
        This form explains in more detail what saying “yes” or “no” to this
        broad consent will mean to you. If you don’t choose either “yes” or “no”
        after reading this form, your identifiable information might still be
        used for some low risk research without your consent. It is better if
        you say “yes” or “no” on this broad consent form, so that your choice is
        clear.
      </p>
      <p className={blockCls}>
        Remember, this form applies only to research with identifiable
        information. Researchers can always use de-identified health information
        for research, without getting any person’s consent and without asking an
        ethics committee for permission.
      </p>
      <H3>What is the Purpose of a Broad Consent?</H3>
      <p className={blockCls}>
        If you say “yes” in this form, USC may use your identifiable information
        for the purpose of medical and scientific research, now and into the
        future, for as long as they are needed for this purpose.
      </p>
      <H3>What Types of Research May be Done?</H3>
      <p className={blockCls}>
        If you say “yes” in this form, there are no plans to tell you about any
        of the specific research that will be done with your identifiable
        information. Possible future research will be related to studying how
        glucose levels and variability are related to each other in daily life.
      </p>
      <H3>Are There Risks of Harm?</H3>
      <p className={blockCls}>
        The main risk in saying “yes” is that your privacy could be violated. We
        will do our best to protect your information from going to people who
        should not have it, including by removing information that could be used
        easily to identify you. The risk that your identifiable information will
        go to someone who should not get it is very small.
      </p>
      <p className={blockCls}>
        Another risk is that your identifiable information could be used in a
        research project to which you might not agree, if you were asked
        specifically about it. The examples listed above should give you a good
        idea of the kinds of research projects that might be done.
      </p>
      <H3>Privacy and Your Protected Health Information</H3>
      <p className={blockCls}>
        In the United States, the personal information that can identify you is
        protected by federal privacy and security regulations issued under the
        Health Insurance Portability and Accountability Act (“HIPAA”). This
        section of this form advises you on your rights under these regulations.
      </p>
      <p className={blockCls}>
        If you say “yes” in this form, we may share your identifiable
        information with regulatory authorities that oversee research, such as
        the U.S. Department of Health and Human Services Office for Human
        Research Protections (OHRP), and with committees and people at USC and
        in other places whose job is to review and oversee research. This
        permission will last as long as we have a scientific need to use and
        share your identifiable information (including identifiable health
        information). If results are published of studies done with your
        identifiable information, your identifying information will not be used
        in those publications.
      </p>
      <H3>Are There Any Benefits?</H3>
      <p className={blockCls}>
        You will not personally benefit from saying “yes” in this form. Research
        with your identifiable information may help others by improving our
        understanding of diabetes, improving health care, and developing new
        scientific knowledge.
      </p>
      <H3>Are There Alternatives to this Broad Consent? Is There a Choice?</H3>
      <p className={blockCls}>
        You are free to say “no” to the use of your identifiable information.
        Saying “yes” to this broad consent is voluntary. No matter what you
        decide, your decision will not affect your ability to use the vitaMAPS
        application.
      </p>
      <H3>
        Can You Change Your Mind and Reverse Your Decision to Give this Broad
        Consent?
      </H3>
      <p className={blockCls}>
        If you say “yes” now, you can later change your mind, but there are some
        limits. If you change your mind, contact Beth Pyatak at
        beth.pyatak@chan.usc.edu. We will not begin new research using your
        identifiable information. If you change your mind, USC will not use your
        identified information for future research.
      </p>
      <H3>Will it Cost Anything?</H3>
      <p className={blockCls}>
        Whether you say “yes,” “no,” or do not respond to this form, there are
        no costs to you.
      </p>
      <H3>Is There Any Payment or Compensation for saying “yes”?</H3>
      <p className={blockCls}>
        If you say “yes,” your identifiable information may be used to create
        products or to deliver services, including some that may be sold and/or
        make money for others. If this happens, there are no plans to give any
        compensation to you. Most uses of information do not lead to commercial
        products or to profit for anyone.
      </p>
      <H3>If You Say “Yes,” Will You Learn More about Your Health?</H3>
      <p className={blockCls}>
        Because this is a broad consent, there are no plans to tell you about
        any specific research studies that might be done with your identifiable
        information, and no plans to give you any results from these studies.
        Most research studies have no clear meaning for the health of specific
        individuals.
      </p>
      <H3>
        Options For Responding to this Request for Broad Consent: What Will
        Happen?
      </H3>
      <p>
        If you give a definite and clear “Yes” or “No” to this broad consent,
        then researchers now and in the future will have a clear idea about what
        they are allowed and not allowed to do with your identifiable
        information. Not giving any answer will also have implications, as
        described below.
      </p>
      <ul className={listCls}>
        <li>
          IF YOU SAY YES: Your identifiable information will be stored and used
          for the kinds of future research described in this broad consent form,
          without anyone asking your permission for each new study. Your
          Identifying information may also be removed from your information,
          allowing them to be used and shared for any future research or other
          purpose.
        </li>
        <li>
          IF YOU SAY NO: The researchers and institutions identified above will
          not store, use or share your identifiable information for the research
          described in this broad consent form. However, identifiers may be
          removed from your information, allowing them to be used for any future
          research or other purpose.
        </li>
        <li>
          IF YOU LEAVE THIS FORM BLANK: If you do not mark “yes” or “no” on this
          form, then it will be the same as if you were never asked to make a
          choice. This means that your identifiable information may only be used
          if researchers ask you to say yes to a specific research study, and
          you agree, or if an IRB allows your identifiable information to be
          used in a study that is low risk to you without asking for your
          consent.
        </li>
      </ul>
      <H3>Questions</H3>
      <p>
        If you have any questions about this broad consent, please contact Beth
        Pyatak at beth.pyatak@chan.usc.edu.
      </p>
    </div>
END
informed_consent1.content = { questions: [{
  type: :raw,
  content: ic_content
}, {
  id: :v1,
  type: :checkbox,
  required: true,
  title: '',
  options: [
    'I declare that I understand and agree with the above information.'
  ],
  show_otherwise: false
}], scores: [] }
informed_consent1.title = ''
informed_consent1.save!
