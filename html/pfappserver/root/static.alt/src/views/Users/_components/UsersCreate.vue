<template>
  <b-card no-body>
    <b-card-header>
      <h4 class="mb-0" v-t="'Create Users'"></h4>
    </b-card-header>
    <b-tabs v-model="modeIndex" card>
      <b-tab title="Single">
        <b-form @submit.prevent="create()">
          <b-form-row align-v="center">
            <b-col sm="12">
              <pf-form-toggle v-model="single.pid_overwrite" :column-label="$t('Username (PID) overwrite')"
                :values="{checked: 1, unchecked: 0}" text="Overwrite the username (PID) if it already exists."
                >{{ (single.pid_overwrite === 1) ? $t('Overwrite') : $t('Ignore') }}</pf-form-toggle>
              <pf-form-input :column-label="$t('Username (PID)')"
                v-model.trim="single.pid"
                :validation="$v.single.pid"
                text="The username to use for login to the captive portal."/>
              <pf-form-input :column-label="$t('Password')"
                v-model="single.password"
                :validation="$v.single.password"
                type="password"
                text="Leave empty to generate a random password."/>
              <pf-form-input :column-label="$t('Login remaining')"
                v-model="single.login_remaining"
                :validation="$v.single.login_remaining"
                type="number"
                text="Leave empty to allow unlimited logins."/>
              <pf-form-input :column-label="$t('Email')"
                v-model.trim="single.email"
                :validation="$v.single.email"
              />
              <pf-form-input :column-label="$t('Sponsor')"
                v-model.trim="single.sponsor"
                :validation="$v.single.sponsor"
              />
              <pf-form-chosen :column-label="$t('Gender')"
                v-model="single.gender"
                label="text"
                track-by="value"
                :placeholder="$t('Choose gender')"
                :options="[{text:$t('Male'), value:'m'}, {text:$t('Female'), value:'f'}, {text:$t('Other'), value:'o'}]"
              ></pf-form-chosen>
              <pf-form-input :column-label="$t('Title')"
                v-model="single.title"
                :validation="$v.single.title"
              />
              <pf-form-input :column-label="$t('Firstname')"
                v-model="single.firstname"
                :validation="$v.single.firstname"
              />
              <pf-form-input :column-label="$t('Lastname')"
                v-model="single.lastname"
                :validation="$v.single.lastname"
              />
              <pf-form-input :column-label="$t('Nickname')"
                v-model="single.nickname"
                :validation="$v.single.nickname"
              />
              <pf-form-input :column-label="$t('Company')"
                v-model="single.company"
                :validation="$v.single.company"
              />
              <pf-form-input :column-label="$t('Telephone number')"
                v-model="single.telephone"
                :filter="globals.regExp.stringPhone"
                :validation="$v.single.telephone"
              />
              <pf-form-input :column-label="$t('Cellphone number')"
                v-model="single.cell_phone"
                :filter="globals.regExp.stringPhone"
                :validation="$v.single.cell_phone"
              />
              <pf-form-input :column-label="$t('Workphone number')"
                v-model="single.work_phone"
                :filter="globals.regExp.stringPhone"
                :validation="$v.single.work_phone"
              />
              <pf-form-input :column-label="$t('Apartment number')"
                v-model="single.apartment_number"
                :filter="globals.regExp.stringPhone"
                :validation="$v.single.apartment_number"
              />
              <pf-form-input :column-label="$t('Building Number')"
                v-model="single.building_number"
                :filter="globals.regExp.stringPhone"
                :validation="$v.single.building_number"
              />
              <pf-form-input :column-label="$t('Room Number')"
                v-model="single.room_number"
                :filter="globals.regExp.stringPhone"
                :validation="$v.single.room_number"
              />
              <pf-form-textarea :column-label="$t('Address')" rows="4" max-rows="6"
                v-model="single.address"
                :validation="$v.single.address"
              />
              <pf-form-datetime :column-label="$t('Anniversary')"
                v-model="single.anniversary"
                :config="{format: 'YYYY-MM-DD'}"
                :validation="$v.single.anniversary"
              />
              <pf-form-datetime :column-label="$t('Birthday')"
                v-model="single.birthday"
                :config="{format: 'YYYY-MM-DD'}"
                :validation="$v.single.birthday"
              />
              <pf-form-textarea :column-label="$t('Notes')"
                v-model="single.notes"
                :validation="$v.single.notes"
                rows="3" max-rows="3"
              />
              <pf-form-input :column-label="$t('Custom Field 1')"
                v-model="single.custom_field_1"
                :validation="$v.single.custom_field_1"
              />
              <pf-form-input :column-label="$t('Custom Field 2')"
                v-model="single.custom_field_2"
                :validation="$v.single.custom_field_2"
              />
              <pf-form-input :column-label="$t('Custom Field 3')"
                v-model="single.custom_field_3"
                :validation="$v.single.custom_field_3"
              />
              <pf-form-input :column-label="$t('Custom Field 4')"
                v-model="single.custom_field_4"
                :validation="$v.single.custom_field_4"
              />
              <pf-form-input :column-label="$t('Custom Field 5')"
                v-model="single.custom_field_5"
                :validation="$v.single.custom_field_5"
              />
              <pf-form-input :column-label="$t('Custom Field 6')"
                v-model="single.custom_field_6"
                :validation="$v.single.custom_field_6"
              />
              <pf-form-input :column-label="$t('Custom Field 7')"
                v-model="single.custom_field_7"
                :validation="$v.single.custom_field_7"
              />
              <pf-form-input :column-label="$t('Custom Field 8')"
                v-model="single.custom_field_8"
                :validation="$v.single.custom_field_8"
              />
              <pf-form-input :column-label="$t('Custom Field 9')"
                v-model="single.custom_field_9"
                :validation="$v.single.custom_field_9"
              />
            </b-col>
          </b-form-row>
        </b-form>
      </b-tab>
      <b-tab :title="$t('Multiple')" v-can:create-multiple="'users'">
        <b-form @submit.prevent="create()">
          <b-form-row align-v="center">
            <b-col sm="12">
              <pf-form-toggle v-model="multiple.pid_overwrite" :column-label="$t('Username (PID) overwrite')"
                :values="{checked: 1, unchecked: 0}" text="Overwrite the username (PID) if it already exists."
                >{{ (multiple.pid_overwrite === 1) ? $t('Overwrite') : $t('Ignore') }}</pf-form-toggle>
              <pf-form-input :column-label="$t('Username Prefix')"
                v-model="multiple.prefix"
                :validation="$v.multiple.prefix"
              />
              <pf-form-input :column-label="$t('Quantity')"
                v-model="multiple.quantity"
                :validation="$v.multiple.quantity"
                type="number"
              />
              <pf-form-input :column-label="$t('Login remaining')"
                v-model="multiple.login_remaining"
                :validation="$v.multiple.login_remaining"
                type="number"
                text="Leave empty to allow unlimited logins."/>
              <pf-form-input :column-label="$t('Firstname')"
                v-model="multiple.firstname"
                :validation="$v.multiple.firstname"
              />
              <pf-form-input :column-label="$t('Lastname')"
                v-model="multiple.lastname"
                :validation="$v.multiple.lastname"
              />
              <pf-form-input :column-label="$t('Company')"
                v-model="multiple.company"
                :validation="$v.multiple.company"
              />
              <pf-form-textarea :column-label="$t('Notes')"
                v-model="multiple.notes"
                :validation="$v.multiple.notes"
                rows="3" max-rows="3"
              />
            </b-col>
          </b-form-row>
        </b-form>
      </b-tab>
    </b-tabs>

    <b-container class="card-body" fluid>
      <b-form-row>
        <b-col sm="12">

          <b-form-group horizontal label-cols="3" :label="$t('Registration Window')">
            <b-row align-v="center">
              <b-col>
                <pf-form-datetime v-model="valid_from"
                  :min="new Date()"
                  :config="{format: 'YYYY-MM-DD'}"
                  :validation="$v.valid_from"
                />
              </b-col>
              <icon name="long-arrow-alt-right"></icon>
              <b-col>
                <pf-form-datetime v-model="expiration"
                  :min="new Date()"
                  :config="{format: 'YYYY-MM-DD'}"
                  :validation="$v.expiration"
                />
              </b-col>
            </b-row>
          </b-form-group>

          <pf-form-actions
            sortable
            v-model="actions"
            column-label="Actions"
            :type-label="$t('Select action type')"
            :value-label="$t('Select action value')"
            :fields="actionFields"
            :validation="$v.actions"
            :invalid-feedback="[
              { [$t('One or more errors exist.')]: !$v.actions.anyError }
            ]"
            @validations="actionsValidations = $event"
          ></pf-form-actions>

        </b-col>
        <b-col sm="4"></b-col>
      </b-form-row>
    </b-container>

    <b-card-footer @mouseenter="$v.$touch()">
      <b-button variant="primary" :disabled="invalidForm" @click="create()">
        <icon name="circle-notch" spin v-show="isLoading"></icon> {{ $t('Create') }}
      </b-button>
    </b-card-footer>
  </b-card>
</template>

<script>
import pfFormActions from '@/components/pfFormActions'
import pfFormChosen from '@/components/pfFormChosen'
import pfFormDatetime from '@/components/pfFormDatetime'
import pfFormInput from '@/components/pfFormInput'
import pfFormTextarea from '@/components/pfFormTextarea'
import pfFormToggle from '@/components/pfFormToggle'

import {
  required,
  minLength,
  maxLength,
  minValue,
  maxValue,
  numeric
} from 'vuelidate/lib/validators'
import {
  and,
  not,
  conditional,
  compareDate,
  isDateFormat,
  userExists,
  requireAllSiblingFieldTypes,
  requireAnySiblingFieldTypes,
  restrictAllSiblingFieldTypes,
  limitSiblingFieldTypes
} from '@/globals/pfValidators'
import { pfRegExp as regExp } from '@/globals/pfRegExp'
import {
  pfDatabaseSchema as schema,
  buildValidationFromTableSchemas
} from '@/globals/pfDatabaseSchema'
import { pfFieldType as fieldType } from '@/globals/pfField'
import bytes from '@/utils/bytes'

const { validationMixin } = require('vuelidate')

export default {
  name: 'UsersCreate',
  components: {
    pfFormActions,
    pfFormChosen,
    pfFormDatetime,
    pfFormInput,
    pfFormTextarea,
    pfFormToggle
  },
  mixins: [
    validationMixin
  ],
  data () {
    return {
      globals: {
        regExp: regExp,
        schema: schema
      },
      actionFields: [
        {
          value: 'set_access_duration',
          text: this.$i18n.t('Access duration'),
          types: [fieldType.DURATION],
          validators: {
            type: {
              /* Require "set_role" */
              [this.$i18n.t('Action requires "Set Role".')]: requireAllSiblingFieldTypes('set_role'),
              /* Restrict "set_unreg_date" */
              [this.$i18n.t('Action conflicts with "Unregistration date".')]: restrictAllSiblingFieldTypes('set_unreg_date'),
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            },
            value: {
              [this.$i18n.t('Value required.')]: required
            }
          }
        },
        {
          value: 'set_access_level',
          text: this.$i18n.t('Access level'),
          types: [fieldType.ADMINROLE],
          validators: {
            type: {
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            },
            value: {
              [this.$i18n.t('Value required.')]: required
            }
          }
        },
        {
          value: 'set_bandwidth_balance',
          text: this.$i18n.t('Bandwidth balance'),
          types: [fieldType.PREFIXMULTIPLIER],
          validators: {
            type: {
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            },
            value: {
              [this.$i18n.t('Value required.')]: required,
              [this.$i18n.t('Value must be greater than {min}bytes.', { min: bytes.toHuman(schema.node.bandwidth_balance.min) })]: minValue(schema.node.bandwidth_balance.min),
              [this.$i18n.t('Value must be less than {max}bytes.', { max: bytes.toHuman(schema.node.bandwidth_balance.max) })]: maxValue(schema.node.bandwidth_balance.max)
            }
          }
        },
        {
          value: 'mark_as_sponsor',
          text: this.$i18n.t('Mark as sponsor'),
          types: [fieldType.NONE],
          validators: {
            type: {
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            }
          }
        },
        {
          value: 'set_role',
          text: this.$i18n.t('Role'),
          types: [fieldType.ROLE],
          validators: {
            type: {
              /* When "Role" is selected, either "Time Balance" or "set_unreg_date" is required */
              [this.$i18n.t('Action requires either "Access duration" or "Unregistration date".')]: requireAnySiblingFieldTypes('set_access_duration', 'set_unreg_date'),
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            },
            value: {
              [this.$i18n.t('Value required.')]: required
            }
          }
        },
        {
          value: 'set_tenant_id',
          text: this.$i18n.t('Tenant ID'),
          types: [fieldType.TENANT],
          validators: {
            type: {
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            },
            value: {
              [this.$i18n.t('Value required.')]: required,
              [this.$i18n.t('Value must be numeric.')]: numeric
            }
          }
        },
        {
          value: 'set_time_balance',
          text: this.$i18n.t('Time balance'),
          types: [fieldType.DURATION],
          validators: {
            type: {
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            },
            value: {
              [this.$i18n.t('Value required.')]: required
            }
          }
        },
        {
          value: 'set_unreg_date',
          text: this.$i18n.t('Unregistration date'),
          types: [fieldType.DATETIME],
          moments: ['1 days', '1 weeks', '1 months', '1 years'],
          validators: {
            type: {
              /* Require "set_role" */
              [this.$i18n.t('Action requires "Set Role".')]: requireAllSiblingFieldTypes('set_role'),
              /* Restrict "set_access_duration" */
              [this.$i18n.t('Action conflicts with "Access duration".')]: restrictAllSiblingFieldTypes('set_access_duration'),
              /* Don't allow elsewhere */
              [this.$i18n.t('Action exists.')]: limitSiblingFieldTypes(0)
            },
            value: {
              [this.$i18n.t('Future date required.')]: compareDate('>=', new Date(), schema.node.unregdate.format, false),
              [this.$i18n.t('Invalid date.')]: isDateFormat(schema.node.unregdate.format)
            }
          }
        }
      ],
      modeIndex: 0,
      single: {
        pid_overwrite: 0,
        pid: '',
        email: '',
        sponsor: '',
        password: '',
        login_remaining: null,
        gender: '',
        title: '',
        firstname: '',
        lastname: '',
        nickname: '',
        company: '',
        telephone: '',
        cell_phone: '',
        work_phone: '',
        address: '',
        apartment_number: '',
        building_number: '',
        room_number: '',
        anniversary: '',
        birthday: '',
        notes: '',
        custom_field_1: '',
        custom_field_2: '',
        custom_field_3: '',
        custom_field_4: '',
        custom_field_5: '',
        custom_field_6: '',
        custom_field_7: '',
        custom_field_8: '',
        custom_field_9: ''
      },
      multiple: {
        pid_overwrite: 0,
        prefix: '',
        quantity: '',
        login_remaining: null,
        firstname: '',
        lastname: '',
        company: '',
        notes: ''
      },
      valid_from: null,
      expiration: null,
      actions: null,
      actionsValidations: {}
    }
  },
  validations () {
    // prefix maxLength depends on the char length of quantity (eg: quantity=1, maxLength=255-1, quantity=1000, maxLength=255-4)
    let prefixMaxLength = schema.person.pid.maxLength - Math.floor(Math.log10(this.multiple.quantity || 1) + 1)

    return {
      single: buildValidationFromTableSchemas(
        schema.person, // use `person` table schema
        schema.password, // use `password` table schema
        { sponsor: schema.person.sponsor }, // `sponsor` column exists in both `person` and `password` tables, fix: overload
        {
          // additional custom validations ...
          pid: {
            [this.$i18n.t('Username required.')]: required,
            [this.$i18n.t('Username exists.')]: not(and(required, userExists, conditional(!this.single.pid_overwrite)))
          },
          email: {
            [this.$i18n.t('Email address required.')]: required
          },
          password: {
            [this.$i18n.t('Password must be at least 6 characters.')]: minLength(6)
          }
        }
      ),
      multiple: buildValidationFromTableSchemas(
        schema.person, // use `person` table schema
        schema.password, // use `password` table schema
        { sponsor: schema.person.sponsor }, // `sponsor` column exists in both `person` and `password` tables, fix: overload
        {
          // additional custom validations ...
          prefix: {
            [this.$i18n.t('Username prefix required.')]: required,
            [this.$i18n.t('Maximum {maxLength} characters.', { maxLength: prefixMaxLength })]: maxLength(prefixMaxLength)
          },
          quantity: {
            [this.$i18n.t('Quantity required.')]: required,
            [this.$i18n.t('Quantity must be numeric.')]: numeric
          },
          valid_from: {
            [this.$i18n.t('Start date required.')]: conditional(!!this.valid_from && this.valid_from !== '0000-00-00'),
            [this.$i18n.t('Date must be today or later.')]: compareDate('>=', new Date(), 'YYYY-MM-DD'),
            [this.$i18n.t('Date must be less than or equal to end date.')]: not(and(required, conditional(this.valid_from), not(compareDate('<=', this.expiration, 'YYYY-MM-DD'))))
          },
          expiration: {
            [this.$i18n.t('End date required.')]: conditional(!!this.expiration && this.expiration !== '0000-00-00'),
            [this.$i18n.t('Date must be today or later.')]: compareDate('>=', new Date(), 'YYYY-MM-DD'),
            [this.$i18n.t('Date must be greater than or equal to start date.')]: not(and(required, conditional(this.expiration), not(compareDate('>=', this.valid_from, 'YYYY-MM-DD'))))
          }
        }
      ),
      actions: this.actionsValidations
    }
  },
  computed: {
    isLoading () {
      return this.$store.getters['$_users/isLoading']
    },
    invalidForm () {
      if (this.modeIndex === 0) {
        return this.$v.single.$invalid || this.isLoading
      } else {
        return false
      }
    }
  },
  methods: {
    create () {
      const base = {
        valid_from: this.valid_from,
        expiration: this.expiration,
        actions: this.actions
      }
      switch (this.modeIndex) {
        case 0: // single
          this.$store.dispatch('$_users/createUser', Object.assign(base, this.single))
          break
        case 1: // multiple
          this.$store.dispatch('$_users/createUser', Object.assign(base, this.single))
          break
        default:
          // noop
      }
    }
  },
  created () {
    this.$store.dispatch('config/getAdminRoles')
    this.$store.dispatch('config/getRoles')
    this.$store.dispatch('config/getTenants')
  }
}
</script>
